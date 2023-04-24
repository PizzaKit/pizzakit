import UIKit

public extension UIStyle where Control == UIButton {

    static var allStyles: PizzaButtonStyles {
        PizzaDesignSystemStore.currentDesignSystem.buttonStyles
    }

}

public extension UIButton {
    func apply(style: UIStyle<UIButton>) {
        style.apply(for: self)
    }
}
