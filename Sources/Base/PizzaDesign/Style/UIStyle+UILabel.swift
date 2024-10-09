import UIKit
import PizzaCore

public extension UIStyle where Control == PizzaLabel {
    static var allStyles: PizzaLabelStyles {
        PizzaDesignSystemStore.currentDesignSystem.labelStyles
    }
}

open class UILabelStyle: UIStyle<PizzaLabel> {

    open func getAttributes() -> [NSAttributedString.Key: Any] {
        fatalError("method must be implemented")
    }

}

public extension StringBuilder {

    convenience init(
        text: String? = nil,
        style: UILabelStyle?
    ) {
        self.init(text: text, initialAttributes: style?.getAttributes() ?? [:])
    }

}
