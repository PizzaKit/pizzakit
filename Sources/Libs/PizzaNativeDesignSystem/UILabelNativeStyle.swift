import UIKit
import PizzaKit

public class UILabelNativeStyle: UILabelStyle {
    public let font: UIFont
    public let color: UIColor
    public let alignment: NSTextAlignment
    public let lineHeight: CGFloat

    public init(
        font: UIFont,
        color: UIColor,
        alignment: NSTextAlignment,
        lineHeight: CGFloat
    ) {
        self.font = font
        self.color = color
        self.alignment = alignment
        self.lineHeight = lineHeight
    }

    public override func apply(for label: PizzaLabel) {
        label.attributedText = StringBuilder(text: label.text)
            .font(font.roundedIfNeeded)
            .lineHeight(lineHeight)
            .alignment(alignment)
            .foregroundColor(color)
            .lineBreakMode(.byTruncatingTail)
            .build()
    }

    public override func getAttributes() -> [NSAttributedString.Key: Any] {
        StringBuilder()
            .font(font.roundedIfNeeded)
            .lineHeight(lineHeight)
            .alignment(alignment)
            .foregroundColor(color)
            .attributes
    }
}
