import UIKit

public extension UIColor {

    static var palette: PizzaPalette {
        PizzaDesignSystemStore.currentDesignSystem.palette
    }

}
