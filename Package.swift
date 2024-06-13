// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TlAppleWalletCapacitorPlugin",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "TlAppleWalletCapacitorPlugin",
            targets: ["TLAppleWalletPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "TLAppleWalletPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/TLAppleWalletPlugin"),
        .testTarget(
            name: "TLAppleWalletPluginTests",
            dependencies: ["TLAppleWalletPlugin"],
            path: "ios/Tests/TLAppleWalletPluginTests")
    ]
)
