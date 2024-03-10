// swift-tools-version:5.9

import PackageDescription

let package = Package(
	name: "KEFoundation",
	platforms: [
		.iOS(.v14),
		.macCatalyst(.v14),
		.watchOS(.v8),
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
	],
	targets: [
		.target(
			name: "KEFoundation",
			dependencies: [],
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
