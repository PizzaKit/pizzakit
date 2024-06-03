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
        )
    ],
    dependencies: [
        // Other PizzaKit repos
        .package(
            url: "https://github.com/PizzaKit/pizzaicon",
            from: "1.0.0"
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
                .product(name: "SPIndicator", package: "SPIndicator"),
                .product(name: "PizzaIcon", package: "pizzaicon")
            ]
        ),
        .target(
            name: "PizzaNavigation",
            dependencies: ["PizzaCore", "PizzaDesign"]
        ),
        .target(
            name: "PizzaServices",
            dependencies: [
                "PizzaCore",
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Defaults", package: "Defaults"),
                .product(name: "Reachability", package: "Reachability")
            ],
            resources: [.copy("PrivacyInfo.xcprivacy")]
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
            name: "PizzaComponents",
            dependencies: ["PizzaDesign"]
        ),
        .target(
            name: "PizzaKit",
            dependencies: [
                "PizzaServices",
                "PizzaPopup",
                "PizzaAlert",
                "PizzaComponents",
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
