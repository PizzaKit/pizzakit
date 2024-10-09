import UIKit
import PizzaCore
import PizzaDesign

public struct PizzaCardPopupInfoStyle {

    public enum ButtonAxis {
        case vertical
        case horizontal
    }

    public let contentToViewInsets: UIEdgeInsets
    /// Если картинка будет иметь тип `.customView` размер не будет выставляться
    public let imageSize: CGSize?
    public let imageToTitleOffset: CGFloat
    public let imageTintColor: UIColor
    public let titleToDescriptionOffset: CGFloat
    public let descriptionToBeforeButtonOffset: CGFloat
    public let descriptionToButtonOffset: CGFloat
    public let betweenButtonsOffset: CGFloat
    public let titleStyle: UIStyle<PizzaLabel>
    public let descriptionStyle: UIStyle<PizzaLabel>
    public let primaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let secondaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let buttonAxis: ButtonAxis

    public init(
        contentToViewInsets: UIEdgeInsets = .init(
            top: 32,
            left: 16,
            bottom: 16,
            right: 16
        ),
        imageSize: CGSize? = .init(side: 96),
        imageToTitleOffset: CGFloat = 16,
        imageTintColor: UIColor = .tintColor,
        titleToDescriptionOffset: CGFloat = 8,
        descriptionToBeforeButtonOffset: CGFloat = 20,
        descriptionToButtonOffset: CGFloat = 32,
        betweenButtonsOffset: CGFloat = 8,
        titleStyle: UIStyle<PizzaLabel> = .allStyles.title2(color: .palette.label, alignment: .center),
        descriptionStyle: UIStyle<PizzaLabel> = .allStyles.body(color: .palette.label, alignment: .center),
        primaryButtonStyleProvider: @escaping PizzaReturnClosure<String, UIStyle<UIButton>> = { title in
            return .allStyles.standard(
                title: title,
                size: .large,
                type: .primary
            )
        },
        secondaryButtonStyleProvider: @escaping PizzaReturnClosure<String, UIStyle<UIButton>> = { title in
            return .allStyles.standard(
                title: title,
                size: .large,
                type: .secondary
            )
        },
        buttonAxis: ButtonAxis = .vertical
    ) {
        self.contentToViewInsets = contentToViewInsets
        self.imageSize = imageSize
        self.imageToTitleOffset = imageToTitleOffset
        self.imageTintColor = imageTintColor
        self.titleToDescriptionOffset = titleToDescriptionOffset
        self.descriptionToBeforeButtonOffset = descriptionToBeforeButtonOffset
        self.descriptionToButtonOffset = descriptionToButtonOffset
        self.betweenButtonsOffset = betweenButtonsOffset
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.primaryButtonStyleProvider = primaryButtonStyleProvider
        self.secondaryButtonStyleProvider = secondaryButtonStyleProvider
        self.buttonAxis = buttonAxis
    }

}
