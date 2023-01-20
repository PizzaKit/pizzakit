// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "PizzaKit",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14), 
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
            url: "https://github.com/ra1028/Carbon",
            revision: "9e572593e02ce77e54932d46d130054a13e2a056"
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
        ),
        .target(
            name: "PizzaForm",
            dependencies: ["PizzaKit", "Carbon"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
