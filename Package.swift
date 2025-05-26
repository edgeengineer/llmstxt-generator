// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LLMSTxtGenerator",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ExampleLibrary",
            targets: ["ExampleLibrary"]
        ),
        .plugin(
            name: "LLMSTxtPlugin",
            targets: ["LLMSTxtPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        .target(
            name: "ExampleLibrary",
            dependencies: []
        ),
        .plugin(
            name: "LLMSTxtPlugin",
            capability: .command(
                intent: .custom(verb: "generate-llms-txt", description: "Generate llms.txt file from Swift package")
            )
        ),
        .testTarget(
            name: "ExampleLibraryTests",
            dependencies: ["ExampleLibrary"]
        )
    ]
)