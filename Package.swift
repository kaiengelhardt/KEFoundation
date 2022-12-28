// swift-tools-version:5.7

import PackageDescription

let package = Package(
	name: "KEFoundation",
	platforms: [
		.iOS(.v14),
		.macCatalyst(.v14),
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
			path: "KEFoundation"
		),
		.testTarget(
			name: "KEFoundation-Unit-Tests",
			dependencies: ["KEFoundation"],
			path: "KEFoundation-Unit-Tests"
		),
	]
)
