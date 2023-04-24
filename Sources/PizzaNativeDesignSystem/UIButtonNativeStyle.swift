import UIKit
import PizzaKit

public class UIButtonStyle: UIStyle<UIButton> {

    public let backgroundColor: UIColor
    public let cornerRadius: CGFloat
    public let height: CGFloat
    public let titleStyle: UIStyle<UILabel>

    public init(
        backgroundColor: UIColor,
        cornerRadius: CGFloat,
        height: CGFloat,
        titleStyle: UIStyle<UILabel>
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.titleStyle = titleStyle
    }

    public override func apply(for: UIButton) {

    }

}
