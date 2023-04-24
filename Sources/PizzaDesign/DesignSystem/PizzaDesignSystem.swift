import UIKit

public protocol PizzaPalette {
    var label: UIColor { get }
    var labelError: UIColor { get }
    var labelSecondary: UIColor { get }
    var labelTertiary: UIColor { get }

    var background: UIColor { get }
    var backgroundSecondary: UIColor { get }
}

public protocol PizzaAnimationConstants {
    var standardDuration: TimeInterval { get }
    var fastDuration: TimeInterval { get }
}

public protocol PizzaNavControllerStyles {
    var largeTitle: UIStyle<UINavigationController> { get }
    var standardTitle: UIStyle<UINavigationController> { get }
}

public protocol PizzaLabelStyles {
    func bodyLabel(alignment: NSTextAlignment) -> UIStyle<PizzaLabel>
    func bodyTint(alignment: NSTextAlignment) -> UIStyle<PizzaLabel>
    func bodyLabelSemibold(alignment: NSTextAlignment) -> UIStyle<PizzaLabel>
    func bodySecondaryLabel(alignment: NSTextAlignment) -> UIStyle<PizzaLabel>

    func rubric2Label(alignment: NSTextAlignment) -> UIStyle<PizzaLabel>
    func rubric2SecondaryLabel(alignment: NSTextAlignment) -> UIStyle<PizzaLabel>
}

public protocol PizzaTextFieldStyles {
    func standardTextField(placeholder: String?) -> UIStyle<UITextField>
    func standardErrorTextField(placeholder: String?) -> UIStyle<UITextField>
    func emailTextField(placeholder: String?) -> UIStyle<UITextField>
    func emailErrorTextField(placeholder: String?) -> UIStyle<UITextField>
}

public enum PizzaButtonStylesSize {
    case large
    case medium
    case small
}
public enum PizzaButtonStylesAlignment {
    case leading
    case center
}
public protocol PizzaButtonStyles {
    func buttonHorizontal(
        size: PizzaButtonStylesSize,
        alignment: PizzaButtonStylesAlignment
    ) -> UIStyle<UIButton>
}

public protocol PizzaTabBarControllerStyles {
    var standard: UIStyle<UITabBarController> { get }
}

public protocol PizzaDesignSystem {
    var palette: PizzaPalette { get }

    var labelStyles: PizzaLabelStyles { get }
    var navControllerStyle: PizzaNavControllerStyles { get }
    var buttonStyles: PizzaButtonStyles { get }
    var textFieldStyles: PizzaTextFieldStyles { get }
    var tabBarControllerStyles: PizzaTabBarControllerStyles { get }

    var animationConstants: PizzaAnimationConstants { get }
}

public struct PizzaDesignSystemStore {
    public static var currentDesignSystem: PizzaDesignSystem!
}
