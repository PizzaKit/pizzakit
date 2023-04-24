import UIKit

public extension UIStyle where Control == PizzaLabel {
    static var allStyles: PizzaLabelStyles {
        PizzaDesignSystemStore.currentDesignSystem.labelStyles
    }
}
