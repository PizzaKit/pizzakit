// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PizzaKit",
    platforms: [
        .iOS(.v13), 
        .tvOS(.v13), 
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "PizzaKit",
            targets: ["PizzaKit"]
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
                "NVActivityIndicatorView",
                "Nuke",
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "NukeExtensions", package: "Nuke")
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
        )
    ],
    swiftLanguageVersions: [.v5]
)
