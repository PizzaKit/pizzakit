import UIKit

public extension UIStyle where Control == UINavigationController {

    static var allStyles: PizzaNavControllerStyles {
        PizzaDesignSystemStore.currentDesignSystem.navControllerStyle
    }

}

public extension UINavigationController {
    func apply(style: UIStyle<UINavigationController>) {
        style.apply(for: self)
    }
}
