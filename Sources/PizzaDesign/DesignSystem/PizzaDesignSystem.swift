import UIKit

public struct PizzaDesignSystem {

    public static var current: PizzaDesignSystem!

    public let palette: PizzaPalette
    public let animationDuration: TimeInterval
    public let fastAnimationDuration: TimeInterval

    public init(
        palette: PizzaPalette,
        animationDuration: TimeInterval,
        fastAnimationDuration: TimeInterval
    ) {
        self.palette = palette
        self.animationDuration = animationDuration
        self.fastAnimationDuration = fastAnimationDuration
    }

    public static var `default` = PizzaDesignSystem(
        palette: .default,
        animationDuration: 0.3,
        fastAnimationDuration: 0.2
    )

}
