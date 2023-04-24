import UIKit

public extension UIColor {

    public static var palette: PizzaPalette {
        PizzaDesignSystemStore.currentDesignSystem.palette
    }

}
