// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "PizzaKit",
    defaultLocalization: "en",
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
            name: "PizzaFirebaseFeatureToggle",
            targets: ["PizzaFirebaseFeatureToggle"]
        ),
        .library(
            name: "PizzaFirebasePushNotification",
            targets: ["PizzaFirebasePushNotification"]
        ),
        .library(
            name: "PizzaFeatureToggleUI",
            targets: ["PizzaFeatureToggleUI"]
        ),
        .library(
            name: "PizzaAppThemeUI",
            targets: ["PizzaAppThemeUI"]
        )
    ],
    dependencies: [
        // design
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
            url: "https://github.com/SFSafeSymbols/SFSafeSymbols",
            from: "4.1.1"
        ),
        .package(
            url: "https://github.com/ivanvorobei/SPIndicator",
            from: "1.6.4"
        ),

        // popup
        .package(
            url: "https://github.com/huri000/SwiftEntryKit",
            from: "2.0.0"
        ),

        // services
        .package(
            url: "https://github.com/sindresorhus/Defaults",
            from: "7.1.0"
        ),
        .package(
            url: "https://github.com/evgenyneu/keychain-swift",
            from: "20.0.0"
        ), 
        .package(
            url: "https://github.com/Alecrim/Reachability",
            from: "1.2.1"
        ),

        // feature toggle
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "10.8.0"
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
            dependencies: [
                "PizzaCore",
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Defaults", package: "Defaults"),
                .product(name: "Reachability", package: "Reachability")
            ]
        ),
        .target(
            name: "PizzaPopup",
            dependencies: [
                "PizzaDesign",
                "PizzaNavigation",
                .product(name: "SwiftEntryKit", package: "SwiftEntryKit")
            ]
        ),
        .target(
            name: "PizzaAlert",
            dependencies: [
                "PizzaDesign", 
                "PizzaNavigation"
            ]
        ),
        .target(
            name: "PizzaForm",
            dependencies: ["PizzaDesign"]
        ),
        .target(
            name: "PizzaKit",
            dependencies: [
                "PizzaServices",
                "PizzaPopup",
                "PizzaAlert",
                "PizzaForm",
            ]
        ),
        .target(
            name: "PizzaFirebaseFeatureToggle",
            dependencies: [
                "PizzaServices", 
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "PizzaFirebasePushNotification",
            dependencies: [
                "PizzaServices", 
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ]
        ),
        .target(
            name: "PizzaFeatureToggleUI",
            dependencies: [
                "PizzaKit"
            ]
        ),
        .target(
            name: "PizzaAppThemeUI",
            dependencies: [
                "PizzaKit"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
