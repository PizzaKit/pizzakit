import UIKit

public extension UIStyle where Control == UITabBarController {

    static var allStyles: PizzaTabBarControllerStyles {
        PizzaDesignSystemStore.currentDesignSystem.tabBarControllerStyles
    }

}

public extension UITabBarController {
    func apply(style: UIStyle<UITabBarController>) {
        style.apply(for: self)
    }
}
