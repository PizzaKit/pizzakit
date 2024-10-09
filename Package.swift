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
        // Libs
        .library(
            name: "PizzaNativeDesignSystem",
            targets: ["PizzaNativeDesignSystem"]
        ),
        .library(
            name: "PizzaAppThemeUI",
            targets: ["PizzaAppThemeUI"]
        ),
        .library(
            name: "PizzaBlockingScreen",
            targets: ["PizzaBlockingScreen"]
        ),
        .library(
            name: "PizzaDesignSystemUI",
            targets: ["PizzaDesignSystemUI"]
        ),
        .library(
            name: "PizzaOnboarding",
            targets: ["PizzaOnboarding"]
        ),
        .library(
            name: "PizzaFirebasePushNotification",
            targets: ["PizzaFirebasePushNotification"]
        ),
        .library(
            name: "PizzaFirebaseFeatureToggleUI",
            targets: ["PizzaFirebaseFeatureToggleUI"]
        ),
        .library(
            name: "PizzaFirebaseFeatureToggle",
            targets: ["PizzaFirebaseFeatureToggle"]
        ),
        .library(
            name: "PizzaAnalyticsWindowTracker",
            targets: ["PizzaAnalyticsWindowTracker"]
        ),

        // Base
        .library(
            name: "PizzaKit",
            targets: ["PizzaKit"]
        )
    ],
    dependencies: [
        // Libs
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "11.3.0"
        ),
        .package(
            url: "https://github.com/alexfilimon/AnyAnalytics", 
            from: "1.0.2"
        ),

        // Other PizzaKit repos
        .package(
            url: "https://github.com/PizzaKit/pizzaicon",
            from: "1.2.0"
        ),

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
            url: "https://github.com/alexfilimon/SwiftEntryKit",
            from: "2.0.1"
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
        .package(
            url: "https://github.com/codykerns/StableID", 
            from: "0.2.0"
        ),

        // navigation
        .package(
            url: "https://github.com/QuickBirdEng/XCoordinator", 
            from: "2.2.1"
        )
    ],
    targets: [
        // Libs
        .target(
            name: "PizzaNativeDesignSystem",
            dependencies: [
                "PizzaKit"
            ],
            path: "Sources/Libs/PizzaNativeDesignSystem"
        ),
        .target(
            name: "PizzaAppThemeUI",
            dependencies: [
                "PizzaKit"
            ],
            path: "Sources/Libs/PizzaAppThemeUI",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "PizzaBlockingScreen",
            dependencies: [
                "PizzaKit"
            ],
            path: "Sources/Libs/PizzaBlockingScreen"
        ),
        .target(
            name: "PizzaDesignSystemUI",
            dependencies: [
                "PizzaKit"
            ],
            path: "Sources/Libs/PizzaDesignSystemUI"
        ),
        .target(
            name: "PizzaOnboarding",
            dependencies: [
                "PizzaKit"
            ],
            path: "Sources/Libs/PizzaOnboarding"
        ),
        .target(
            name: "PizzaFirebasePushNotification",
            dependencies: [
                "PizzaKit",
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk")
            ],
            path: "Sources/Libs/PizzaFirebasePushNotification"
        ),
        .target(
            name: "PizzaFirebaseFeatureToggleUI",
            dependencies: [
                "PizzaKit",
                .product(name: "FirebaseInstallations", package: "firebase-ios-sdk")
            ],
            path: "Sources/Libs/PizzaFirebaseFeatureToggleUI"
        ),
        .target(
            name: "PizzaFirebaseFeatureToggle",
            dependencies: [
                "PizzaKit",
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ],
            path: "Sources/Libs/PizzaFirebaseFeatureToggle"
        ),
        .target(
            name: "PizzaAnalyticsWindowTracker",
            dependencies: [
                "PizzaKit",
                .product(name: "AnyAnalytics", package: "AnyAnalytics")
            ],
            path: "Sources/Libs/PizzaAnalyticsWindowTracker"
        ),

        // Base
        .target(
            name: "PizzaCore",
            path: "Sources/Base/PizzaCore"
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
                .product(name: "SPIndicator", package: "SPIndicator"),
                .product(name: "PizzaIcon", package: "pizzaicon")
            ],
            path: "Sources/Base/PizzaDesign"
        ),
        .target(
            name: "PizzaServices",
            dependencies: [
                "PizzaCore",
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Defaults", package: "Defaults"),
                .product(name: "Reachability", package: "Reachability"),
                .product(name: "StableID", package: "StableID")
            ],
            path: "Sources/Base/PizzaServices",
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .target(
            name: "PizzaPopup",
            dependencies: [
                "PizzaDesign",
                .product(name: "SwiftEntryKit", package: "SwiftEntryKit")
            ],
            path: "Sources/Base/PizzaPopup"
        ),
        .target(
            name: "PizzaAlert",
            dependencies: [
                "PizzaNavigation",
            ],
            path: "Sources/Base/PizzaAlert"
        ),
        .target(
            name: "PizzaComponents",
            dependencies: ["PizzaDesign"],
            path: "Sources/Base/PizzaComponents"
        ),
        .target(
            name: "PizzaKit",
            dependencies: [
                "PizzaServices",
                "PizzaPopup",
                "PizzaAlert",
                "PizzaComponents",
            ],
            path: "Sources/Base/PizzaKit"
        ),
        .target(
            name: "PizzaNavigation",
            dependencies: [
                "PizzaCore",
                "PizzaDesign",
                .product(name: "XCoordinatorCombine", package: "XCoordinator")
            ],
            path: "Sources/Base/PizzaNavigation"
        )
    ],
    swiftLanguageVersions: [.v5]
)
