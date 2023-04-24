import UIKit

public extension TimeInterval {

    public static var animationConstants: PizzaAnimationConstants {
        PizzaDesignSystemStore.currentDesignSystem.animationConstants
    }

}
