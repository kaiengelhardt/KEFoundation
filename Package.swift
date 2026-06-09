// swift-tools-version:5.10

import PackageDescription

let package = Package(
	name: "KEFoundation",
	platforms: [
		.iOS(.v14),
		.macOS(.v11),
		.macCatalyst(.v14),
		.watchOS(.v9),
		.tvOS(.v14),
		.visionOS(.v1),
	],
	products: [
		.library(
			name: "KEFoundation",
			targets: ["KEFoundation"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/kaiengelhardt/consti", from: "1.0.3"),
	],
	targets: [
		.target(
			name: "KEFoundation",
			dependencies: [
				.product(name: "Consti", package: "Consti", condition: .when(platforms: [
					.iOS,
					.macOS,
					.macCatalyst,
					.tvOS,
					.visionOS,
				])),
			],
			path: "KEFoundation",
			swiftSettings: [
				.enableExperimentalFeature("StrictConcurrency"),
			]
		),
		.testTarget(
			name: "KEFoundation-Unit-Tests",
			dependencies: ["KEFoundation"],
			path: "KEFoundation-Unit-Tests"
		),
	]
)
