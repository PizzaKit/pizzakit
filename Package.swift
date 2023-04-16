// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "PizzaKit",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15), 
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "PizzaKit",
            targets: ["PizzaKit"]
        ),
        .library(
            name: "PizzaForm",
            targets: ["PizzaForm"]
        ),
        .library(
            name: "PizzaFeatureToggle",
            targets: ["PizzaFeatureToggle"]
        ),
        .library(
            name: "PizzaFeatureToggleUI",
            targets: ["PizzaFeatureToggleUI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/kean/Nuke",
            from: "11.3.1"
        ),
        .package(
            url: "https://github.com/SnapKit/SnapKit",
            from: "5.6.0"
        ),
        .package(
            url: "https://github.com/ninjaprox/NVActivityIndicatorView",
            from: "5.1.1"
        ),
        .package(
            url: "https://github.com/alxrguz/ALPopup",
            from: "1.1.0"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "10.8.0"
        ),
        .package(
            url: "https://github.com/SFSafeSymbols/SFSafeSymbols",
            from: "4.1.1"
        ),
        .package(
            url: "https://github.com/ivanvorobei/SPIndicator",
            from: "1.6.4"
        )
    ],
    targets: [
        .target(
            name: "PizzaCore"
        ),
        .target(
            name: "PizzaDesign",
            dependencies: [
                "PizzaCore",
                .product(name: "NVActivityIndicatorView", package: "NVActivityIndicatorView"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "NukeExtensions", package: "Nuke"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                .product(name: "SPIndicator", package: "SPIndicator")
            ]
        ),
        .target(
            name: "PizzaNavigation",
            dependencies: ["PizzaCore"]
        ),
        .target(
            name: "PizzaServices",
            dependencies: ["PizzaCore"]
        ),
        .target(
            name: "PizzaPopup",
            dependencies: ["PizzaDesign", "ALPopup"]
        ),
        .target(
            name: "PizzaAlert",
            dependencies: ["PizzaCore", "PizzaNavigation"]
        ),
        .target(
            name: "PizzaKit",
            dependencies: [
                "PizzaCore",
                "PizzaDesign",
                "PizzaNavigation",
                "PizzaServices",
                "PizzaPopup",
                "PizzaAlert"
            ]
        ),
        .target(
            name: "PizzaForm",
            dependencies: ["PizzaKit"]
        ),
        .target(
            name: "PizzaFeatureToggle",
            dependencies: [
                "PizzaKit", 
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "PizzaFeatureToggleUI",
            dependencies: [
                "PizzaForm",
                "PizzaFeatureToggle",
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
