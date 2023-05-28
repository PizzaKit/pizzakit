import UIKit

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
