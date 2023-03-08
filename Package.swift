// swift-tools-version: 5.7

///
import PackageDescription

///
let package = Package(
    name: "data-in-keychain",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "data-in-keychain",
            targets: ["data-in-keychain"]
        ),
    ],
    dependencies: [
        
        ///
        .package(
            url: "https://github.com/bootstrappersmn/OSErrorModule",
            from: "0.1.1"
        ),
    ],
    targets: [
        .target(
            name: "data-in-keychain",
            dependencies: [
                "OSErrorModule",
            ]
        ),
        .testTarget(
            name: "data-in-keychain-tests",
            dependencies: ["data-in-keychain"]
        ),
    ]
)
