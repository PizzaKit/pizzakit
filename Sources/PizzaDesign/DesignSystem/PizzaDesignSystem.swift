import UIKit

public protocol PizzaPalette {
    var label: UIColor { get }
    var labelError: UIColor { get }
    var labelSecondary: UIColor { get }
    var labelTertiary: UIColor { get }
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

    func largeTitle(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func title1(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>
    func title2(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>
    func title3(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func headline(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func body(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func callout(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func subhead(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func footnote(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>

    func caption1(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>
    func caption2(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UIStyle<PizzaLabel>
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
public enum PizzaButtonStylesType {
    case primary
    case secondary
    case tertiary
}
public protocol PizzaButtonStyles {
    func standard(
        title: String?,
        size: PizzaButtonStylesSize,
        type: PizzaButtonStylesType
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
