import UIKit
import PizzaKit

public struct PizzaNativeDesignSystem: PizzaDesignSystem {

    public let palette: PizzaPalette = PizzaNativePalette()
    public let labelStyles: PizzaLabelStyles = PizzaNativeLabelStyles()
    public let navControllerStyle: PizzaNavControllerStyles = PizzaNativeNavControllerStyles()
    public let buttonStyles: PizzaButtonStyles = PizzaNativeButtonStyles()
    public let textFieldStyles: PizzaTextFieldStyles = PizzaNativeTextFieldStyles()
    public let animationConstants: PizzaAnimationConstants = PizzaNativeAnimationConstants()
    public var tabBarControllerStyles: PizzaTabBarControllerStyles = PizzaNativeTabBarControllerStyles()

}

public struct PizzaNativePalette: PizzaPalette {

    public let label: UIColor = .label
    public let labelError: UIColor = .systemRed
    public let labelSecondary: UIColor = .secondaryLabel
    public let labelTertiary: UIColor = .tertiaryLabel
    public let background: UIColor = .systemBackground
    public let backgroundSecondary: UIColor = .secondarySystemBackground

}

public struct PizzaNativeLabelStyles: PizzaLabelStyles {

    public func bodyLabel(alignment: NSTextAlignment) -> UIStyle<PizzaLabel> {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            color: .palette.label,
            alignment: alignment,
            lineHeight: 22
        )
    }

    public func bodyTint(alignment: NSTextAlignment) -> UIStyle<PizzaLabel> {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            color: .tintColor,
            alignment: alignment,
            lineHeight: 22
        )
    }

    public func bodyLabelSemibold(alignment: NSTextAlignment) -> UIStyle<PizzaLabel> {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 17, weight: .semibold).roundedIfNeeded,
            color: .palette.label,
            alignment: alignment,
            lineHeight: 22
        )
    }

    public func bodySecondaryLabel(alignment: NSTextAlignment) -> UIStyle<PizzaLabel> {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            color: .palette.labelSecondary,
            alignment: alignment,
            lineHeight: 22
        )
    }

    public func rubric2Label(alignment: NSTextAlignment) -> UIStyle<PizzaLabel> {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 13).roundedIfNeeded,
            color: .palette.label,
            alignment: alignment,
            lineHeight: 18
        )
    }

    public func rubric2SecondaryLabel(alignment: NSTextAlignment) -> UIStyle<PizzaLabel> {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 13).roundedIfNeeded,
            color: .palette.labelSecondary,
            alignment: alignment,
            lineHeight: 18
        )
    }

}

public struct PizzaNativeNavControllerStyles: PizzaNavControllerStyles {

    public let largeTitle: UIStyle<UINavigationController> = UINavigationControllerNativeStyle(
        supportLargeTitle: true
    )
    public let standardTitle: UIStyle<UINavigationController> = UINavigationControllerNativeStyle(
        supportLargeTitle: false
    )

}

public struct PizzaNativeButtonStyles: PizzaButtonStyles {

    public func buttonHorizontal(
        size: PizzaButtonStylesSize,
        alignment: PizzaButtonStylesAlignment
    ) -> UIStyle<UIButton> {
        fatalError()
        // TODO: add button style
    }

}

public struct PizzaNativeTextFieldStyles: PizzaTextFieldStyles {

    public func standardTextField(placeholder: String?) -> UIStyle<UITextField> {
        UITextFieldNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            textColor: .palette.label,
            placeholderColor: .palette.labelTertiary,
            placeholder: placeholder,
            alignment: .left,
            keyboardType: .default,
            autocapitalizationType: .sentences,
            autocorrectionType: .default,
            returnKeyType: .default
        )
    }

    public func standardErrorTextField(placeholder: String?) -> UIStyle<UITextField> {
        UITextFieldNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            textColor: .palette.labelError,
            placeholderColor: .palette.labelTertiary,
            placeholder: placeholder,
            alignment: .left,
            keyboardType: .default,
            autocapitalizationType: .sentences,
            autocorrectionType: .default,
            returnKeyType: .default
        )
    }

    public func emailTextField(placeholder: String?) -> UIStyle<UITextField> {
        UITextFieldNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            textColor: .palette.label,
            placeholderColor: .palette.labelTertiary,
            placeholder: placeholder,
            alignment: .left,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
    }

    public func emailErrorTextField(placeholder: String?) -> UIStyle<UITextField> {
        UITextFieldNativeStyle(
            font: .systemFont(ofSize: 17).roundedIfNeeded,
            textColor: .palette.labelError,
            placeholderColor: .palette.labelTertiary,
            placeholder: placeholder,
            alignment: .left,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
    }

}

public struct PizzaNativeAnimationConstants: PizzaAnimationConstants {

    public let standardDuration: TimeInterval = 0.3
    public let fastDuration: TimeInterval = 0.15

}

public struct PizzaNativeTabBarControllerStyles: PizzaTabBarControllerStyles {

    public var standard: UIStyle<UITabBarController> = UITabBarControllerNativeStyle()

}
