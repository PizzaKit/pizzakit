import UIKit

public extension UIStyle where Control == UILabel {
    static func bodyLabel(
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelStyle(
            font: .systemFont(ofSize: 17),
            color: .palette.labelColor,
            alignment: alignment
        )
    }
    static func bodyLabelSecondary(
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelStyle(
            font: .systemFont(ofSize: 17),
            color: .palette.labelSecondaryColor,
            alignment: alignment
        )
    }
    static func bodyLabelSemibold(
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelStyle(
            font: .systemFont(ofSize: 17),
            color: .palette.labelColor,
            alignment: alignment
        )
    }
    static func rubric2Label(
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelStyle(
            font: .systemFont(ofSize: 13),
            color: .palette.labelColor,
            alignment: alignment
        )
    }
    static func rubric2Secondary(
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelStyle(
            font: .systemFont(ofSize: 13),
            color: .palette.labelSecondaryColor,
            alignment: alignment
        )
    }
}

public class UILabelStyle: UIStyle<UILabel> {
    public let font: UIFont
    public let color: UIColor
    public let alignment: NSTextAlignment

    public init(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.font = font
        self.color = color
        self.alignment = alignment
    }

    public override func apply(for label: UILabel) {
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
    }
}
