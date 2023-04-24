import UIKit

public extension UIStyle where Control == UITextField {

    static var allStyles: PizzaTextFieldStyles {
        PizzaDesignSystemStore.currentDesignSystem.textFieldStyles
    }

}

public extension UITextField {
    func apply(style: UIStyle<UITextField>) {
        style.apply(for: self)
    }
}
