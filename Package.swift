// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LLMSTxtGenerator",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
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
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0")
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