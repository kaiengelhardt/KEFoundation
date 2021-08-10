//  Created by Keith Harrison https://useyourloaf.com
//  Copyright (c) 2017 Keith Harrison. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

/// A utility class to help you use custom fonts with
/// dynamic type.
///
/// To use this class you must supply the name of a style
/// dictionary for the font when creating the class. The
/// style dictionary should be stored as a property list
/// file in the main bundle.
///
/// The style dictionary contains an entry for each text
/// style that uses the raw string value for each
/// `UIFontTextStyle` as the key.
///
/// The value of each entry is a dictionary with two keys:
///
/// + fontName: A String which is the font name.
/// + fontSize: A number which is the point size to use
///             at the `.large` content size.
///
/// For example to use a 17 pt Noteworthy-Bold font
/// for the `.headline` style at the `.large` content size:
///
///     <dict>
///         <key>UICTFontTextStyleHeadline</key>
///         <dict>
///             <key>fontName</key>
///             <string>Noteworthy-Bold</string>
///             <key>fontSize</key>
///             <integer>17</integer>
///         </dict>
///     </dict>
///
/// You do not need to include an entry for every text style
/// but if you try to use a text style that is not included
/// in the dictionary it will fallback to the system preferred
/// font.
public final class ScaledFont {
	
	private struct FontDescription: Decodable {
		let fontSize: CGFloat
		let fontName: String
	}
	
	private typealias StyleDictionary = [UIFont.TextStyle.RawValue: FontDescription]
	private var styleDictionary: StyleDictionary?
	
	/// Create a `ScaledFont`
	///
	/// - Parameter fontName: Name of a plist file (without the extension)
	///   in the main bundle that contains the style dictionary used to
	///   scale fonts for each text style.
	
	public init(fontName: String, bundle: Bundle = .main) {
		if let url = bundle.url(forResource: fontName, withExtension: "plist"),
		   let data = try? Data(contentsOf: url) {
			let decoder = PropertyListDecoder()
			styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
		}
	}
	
	/// Get the scaled font for the given text style using the
	/// style dictionary supplied at initialization.
	///
	/// - Parameter textStyle: The `UIFontTextStyle` for the
	///   font.
	/// - Returns: A `UIFont` of the custom font that has been
	///   scaled for the users currently selected preferred
	///   text size.
	///
	/// - Note: If the style dictionary does not have
	///   a font for this text style the default preferred
	///   font is returned.
	public func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
		guard
			let fontDescription = styleDictionary?[textStyle.rawValue],
			let font = UIFont(name: fontDescription.fontName, size: fontDescription.fontSize) else
			{
				return UIFont.preferredFont(forTextStyle: textStyle)
			}
		
		let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
		let scaledFont = fontMetrics.scaledFont(for: font)
		return scaledFont
	}
	
	public func unscaledFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
		guard
			let fontDescription = styleDictionary?[textStyle.rawValue],
			let font = UIFont(name: fontDescription.fontName, size: fontDescription.fontSize) else
			{
				return UIFont.preferredFont(forTextStyle: textStyle)
			}
		
		return font
	}
	
	@available(iOS 13, *)
	public func swiftUIFont(forTextStyle textStyle: Font.TextStyle) -> Font {
		let uiKitTextStyle = textStyle.uiKitTextStyle
		guard let fontDescription = styleDictionary?[uiKitTextStyle.rawValue] else {
			return Font.preferredFont(forTextStyle: textStyle)
		}
		
		let fontMetrics = UIFontMetrics(forTextStyle: uiKitTextStyle)
		let scaledSize = fontMetrics.scaledValue(for: fontDescription.fontSize)
		
		let font = Font.custom(fontDescription.fontName, size: scaledSize)
		return font
	}
	
	@available(iOS 13, *)
	public func unscaledSwiftUIFont(forTextStyle textStyle: Font.TextStyle) -> Font {
		let uiKitTextStyle = textStyle.uiKitTextStyle
		guard let fontDescription = styleDictionary?[uiKitTextStyle.rawValue] else {
			return Font.preferredFont(forTextStyle: textStyle)
		}
		
		let font = Font.custom(fontDescription.fontName, size: fontDescription.fontSize)
		return font
	}
}

extension UIFont.TextStyle {
	
	@available(iOS 13, *)
	var swiftUITextStyle: Font.TextStyle {
		if #available(iOS 14, *) {
			switch self {
			case .largeTitle:
				return .largeTitle
			case .title1:
				return .title
			case .title2:
				return .title2
			case .title3:
				return .title3
			case .headline:
				return .headline
			case .subheadline:
				return .subheadline
			case .body:
				return .body
			case .footnote:
				return .footnote
			case .callout:
				return .callout
			case .caption1:
				return .caption
			case .caption2:
				return .caption2
			default:
				return .body
			}
		} else {
			switch self {
			case .largeTitle:
				return .largeTitle
			case .title1:
				return .title
			case .title2:
				return .title
			case .title3:
				return .title
			case .headline:
				return .headline
			case .subheadline:
				return .subheadline
			case .body:
				return .body
			case .footnote:
				return .footnote
			case .callout:
				return .callout
			case .caption1:
				return .caption
			case .caption2:
				return .caption
			default:
				return .body
			}
		}
	}
}

@available(iOS 13, *)
extension Font.TextStyle {
	
	public var uiKitTextStyle: UIFont.TextStyle {
		switch self {
		case .largeTitle:
			return .largeTitle
		case .title:
			return .title1
		case .title2:
			return .title2
		case .title3:
			return .title3
		case .headline:
			return .headline
		case .subheadline:
			return .subheadline
		case .body:
			return .body
		case .footnote:
			return .footnote
		case .callout:
			return .callout
		case .caption:
			return .caption1
		case .caption2:
			return .caption2
		@unknown default:
			return .body
		}
	}
}

@available(iOS 13, *)
extension Font {
	
	public static func preferredFont(forTextStyle textStyle: TextStyle) -> Font {
		switch textStyle {
		case .largeTitle:
			return .largeTitle
		case .title:
			return .title
		case .title2:
			if #available(iOS 14, *) {
				return .title2
			} else {
				return .title
			}
		case .title3:
			if #available(iOS 14, *) {
				return .title3
			} else {
				return .title
			}
		case .headline:
			return .headline
		case .subheadline:
			return .subheadline
		case .body:
			return .body
		case .footnote:
			return .footnote
		case .callout:
			return .callout
		case .caption:
			return .caption
		case .caption2:
			if #available(iOS 14, *) {
				return .caption2
			} else {
				return .caption
			}
		@unknown default:
			return .body
		}
	}
}
