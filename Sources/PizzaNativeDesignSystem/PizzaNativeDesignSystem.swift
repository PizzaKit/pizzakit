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

}

public struct PizzaNativeLabelStyles: PizzaLabelStyles {

    public func largeTitle(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 32, weight: .semibold).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 38
        )
    }

    public func title1(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 28, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 34
        )
    }
    public func title2(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 22, weight: .bold).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 28
        )
    }
    public func title3(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 20, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 25
        )
    }

    public func headline(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 17, weight: .semibold).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 22
        )
    }

    public func body(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 17, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 22
        )
    }

    public func callout(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 16, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 21
        )
    }

    public func subhead(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 15, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 20
        )
    }

    public func footnote(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 13, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 18
        )
    }

    public func footnoteSemibold(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 13, weight: .semibold).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 18
        )
    }

    public func caption1(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 12, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 16
        )
    }
    public func caption2(
        color: UIColor,
        alignment: NSTextAlignment
    ) -> UILabelStyle {
        UILabelNativeStyle(
            font: .systemFont(ofSize: 11, weight: .regular).roundedIfNeeded,
            color: color,
            alignment: alignment,
            lineHeight: 13
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

    public let transparent: UIStyle<UINavigationController> = UINavigationControllerTransparentStyle()

}

public struct PizzaNativeButtonStyles: PizzaButtonStyles {

    public func standard(
        title: String?,
        size: PizzaButtonStylesSize,
        type: PizzaButtonStylesType
    ) -> UIStyle<UIButton> {
        UIButtonStyle(
            title: title,
            backgroundColor: .tintColor,
            size: size,
            type: type,
            attributedTitleProvider: { title in
                switch size {
                case .large, .medium, .custom:
                    return StringBuilder(text: title)
                        .font(.systemFont(ofSize: 17, weight: .semibold).roundedIfNeeded)
                        .lineHeight(21)
                case .small:
                    return StringBuilder(text: title)
                        .font(.systemFont(ofSize: 15, weight: .semibold).roundedIfNeeded)
                        .lineHeight(20)
                }
            },
            isLoading: false,
            imagePadding: 6
        )
    }

    public func loading(
        title: String?,
        size: PizzaButtonStylesSize,
        type: PizzaButtonStylesType
    ) -> UIStyle<UIButton> {
        UIButtonStyle(
            title: title,
            backgroundColor: .tintColor,
            size: size,
            type: type,
            attributedTitleProvider: { title in
                switch size {
                case .large, .medium,. custom:
                    return StringBuilder(text: title)
                        .font(.systemFont(ofSize: 17, weight: .semibold).roundedIfNeeded)
                        .lineHeight(21)
                case .small:
                    return StringBuilder(text: title)
                        .font(.systemFont(ofSize: 15, weight: .semibold).roundedIfNeeded)
                        .lineHeight(20)
                }
            },
            isLoading: true,
            imagePadding: 6
        )
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
