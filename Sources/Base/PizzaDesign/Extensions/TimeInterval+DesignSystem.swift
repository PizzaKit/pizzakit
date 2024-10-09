import UIKit

public extension TimeInterval {

    static var animationConstants: PizzaAnimationConstants {
        PizzaDesignSystemStore.currentDesignSystem.animationConstants
    }

}
