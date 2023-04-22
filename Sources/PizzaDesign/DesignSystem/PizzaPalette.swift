import UIKit

public struct PizzaPalette {

    public let accentColor: UIColor

    public let labelColor: UIColor
    public let labelErrorColor: UIColor
    public let labelSecondaryColor: UIColor
    public let labelTertiaryColor: UIColor

    public let backgroundColor: UIColor

    public init(
        accentColor: UIColor,
        labelColor: UIColor,
        labelErrorColor: UIColor,
        labelSecondaryColor: UIColor,
        labelTertiaryColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.accentColor = accentColor
        self.labelColor = labelColor
        self.labelErrorColor = labelErrorColor
        self.labelSecondaryColor = labelSecondaryColor
        self.labelTertiaryColor = labelTertiaryColor
        self.backgroundColor = backgroundColor
    }

    public static let `default` = PizzaPalette(
        accentColor: .tintColor,
        labelColor: .label,
        labelErrorColor: .systemRed,
        labelSecondaryColor: .secondaryLabel,
        labelTertiaryColor: .tertiaryLabel,
        backgroundColor: .systemBackground
    )

}
