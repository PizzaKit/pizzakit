import UIKit
import PizzaDesign
import PizzaCore
import SwiftEntryKit
import SnapKit
import SFSafeSymbols

public enum PizzaCardPopup {

    public static func dismiss() {
        SwiftEntryKit.dismiss()
    }

    public static func display(
        customView: UIView,
        canBeClosed: Bool
    ) {
        var attributes = EKAttributes()
        attributes.windowLevel = .alerts
        attributes.position = .bottom
        attributes.precedence = .override(priority: .high, dropEnqueuedEntries: false)
        attributes.displayDuration = .infinity
        attributes.positionConstraints.size = .init(
            width: .offset(value: 8),
            height: .intrinsic
        )
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.verticalOffset = 8
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = canBeClosed ? .dismiss : .absorbTouches

        attributes.scroll = canBeClosed ? .enabled(swipeable: true, pullbackAnimation: .easeOut) : .disabled

        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: .black.with(alpha: 0.6))
        attributes.shadow = .none

        attributes.entranceAnimation = EKAttributes.Animation(
            translate: .init(
                duration: 0.4,
                spring: .init(damping: 0.8, initialVelocity: 1)
            )
        )
        attributes.exitAnimation = EKAttributes.Animation(
            translate: .init(
                duration: 0.2
            )
        )

        SwiftEntryKit.display(
            entry: customView,
            using: attributes
        )
    }

    public static func display(
        info: PizzaCardPopupInfo,
        style: PizzaCardPopupInfoStyle
    ) {
        let view = PizzaCardPopupView(
            info: info,
            style: style
        )
        display(customView: view, canBeClosed: style.closable)
    }

}

public struct PizzaCardPopupInfo {

    public enum ImageType {
        case customView(UIView)
        case image(UIImage)
    }

    public enum ButtonType {
        case primary
        case secondary
    }

    public struct Button {
        public let title: String
        public let type: ButtonType
        public let action: PizzaEmptyClosure

        public init(
            title: String,
            type: ButtonType,
            action: @escaping PizzaEmptyClosure
        ) {
            self.title = title
            self.type = type
            self.action = action
        }
    }

    public let image: ImageType?
    public let title: String?
    public let description: String?
    public let buttons: [Button]

    public init(
        image: ImageType?,
        title: String?,
        description: String?,
        buttons: [Button]
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.buttons = buttons
    }

}

public struct PizzaCardPopupInfoStyle {

    public enum ButtonAxis {
        case vertical
        case horizontal
    }

    public let contentToViewInsets: UIEdgeInsets
    public let imageSize: CGSize?
    public let imageToTitleOffset: CGFloat
    public let titleToDescriptionOffset: CGFloat
    public let descriptionToButtonOffset: CGFloat
    public let betweenButtonsOffset: CGFloat
    public let titleStyle: UIStyle<PizzaLabel>
    public let descriptionStyle: UIStyle<PizzaLabel>
    public let primaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let secondaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let closable: Bool
    public let buttonAxis: ButtonAxis

    public static func `default`(
        closable: Bool,
        buttonAxis: ButtonAxis
    ) -> PizzaCardPopupInfoStyle {
        PizzaCardPopupInfoStyle(
            contentToViewInsets: .init(
                top: 32,
                left: 16,
                bottom: 16,
                right: 16
            ),
            imageSize: .init(side: 96),
            imageToTitleOffset: 16,
            titleToDescriptionOffset: 8,
            descriptionToButtonOffset: 32,
            betweenButtonsOffset: 8,
            titleStyle: .allStyles.title2(color: .palette.label, alignment: .center),
            descriptionStyle: .allStyles.body(color: .palette.label, alignment: .center),
            primaryButtonStyleProvider: { title in
                return .allStyles.buttonHorizontal(
                    title: title,
                    size: .large,
                    alignment: .center,
                    type: .primary
                )
            },
            secondaryButtonStyleProvider: { title in
                return .allStyles.buttonHorizontal(
                    title: title,
                    size: .large,
                    alignment: .center,
                    type: .secondary
                )
            },
            closable: closable,
            buttonAxis: buttonAxis
        )
    }

}

public class PizzaCardPopupView: PizzaView {

    private let info: PizzaCardPopupInfo
    private let style: PizzaCardPopupInfoStyle

    public init(
        info: PizzaCardPopupInfo,
        style: PizzaCardPopupInfoStyle
    ) {
        self.info = info
        self.style = style
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func commonInit() {
        super.commonInit()

        backgroundColor = .tertiarySystemGroupedBackground
        layer.cornerCurve = .continuous
        layer.cornerRadius = 20

        UIStackView().do { stack in
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .center
            stack.spacing = 0

            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                    .inset(style.contentToViewInsets)
            }

            // image
            switch info.image {
            case .customView(let view):
                view.snp.makeConstraints { make in
                    make.size.equalTo(style.imageSize ?? .init(side: 96))
                }
                stack.addArrangedSubview(view)
            case .image(let image):
                let imageView = UIImageView(image: image)
                imageView.snp.makeConstraints { make in
                    make.size.equalTo(style.imageSize ?? .init(side: 96))
                }
                stack.addArrangedSubview(imageView)
            case .none:
                break
            }
            if info.image != nil {
                stack.addArrangedSubview(
                    getViewSeparator(height: style.imageToTitleOffset)
                )
            }

            // title
            if let title = info.title {
                let label = PizzaLabel()
                label.style = style.titleStyle
                label.text = title
                label.numberOfLines = 0
                stack.addArrangedSubview(label)
            }
            if info.title != nil {
                stack.addArrangedSubview(
                    getViewSeparator(height: style.titleToDescriptionOffset)
                )
            }

            // description
            if let description = info.description {
                let label = PizzaLabel()
                label.style = style.descriptionStyle
                label.text = description
                label.numberOfLines = 0
                stack.addArrangedSubview(label)
            }
            if info.description != nil {
                stack.addArrangedSubview(
                    getViewSeparator(height: style.descriptionToButtonOffset)
                )
            }

            // buttons
            switch style.buttonAxis {
            case .vertical:
                info.buttons.enumerated().forEach { payload in
                    let (index, buttonInfo) = payload
                    let isLast = info.buttons.count - 1 == index
                    let button = UIButton(primaryAction: .init(handler: { _ in
                        buttonInfo.action()
                    }))
                    switch buttonInfo.type {
                    case .primary:
                        button.apply(style: style.primaryButtonStyleProvider(buttonInfo.title))
                    case .secondary:
                        button.apply(style: style.secondaryButtonStyleProvider(buttonInfo.title))
                    }
                    stack.addArrangedSubview(button)
                    button.snp.makeConstraints { make in
                        make.width.equalToSuperview()
                    }

                    if !isLast {
                        stack.addArrangedSubview(
                            getViewSeparator(height: style.betweenButtonsOffset)
                        )
                    }
                }
            case .horizontal:
                let horizontalStack = UIStackView().do {
                    $0.axis = .horizontal
                    $0.distribution = .fillEqually
                    $0.alignment = .center
                    $0.spacing = style.betweenButtonsOffset
                }
                info.buttons.forEach { buttonInfo in
                    let button = UIButton(primaryAction: .init(handler: { _ in
                        buttonInfo.action()
                    }))
                    switch buttonInfo.type {
                    case .primary:
                        button.apply(style: style.primaryButtonStyleProvider(buttonInfo.title))
                    case .secondary:
                        button.apply(style: style.secondaryButtonStyleProvider(buttonInfo.title))
                    }
                    horizontalStack.addArrangedSubview(button)
                }
                stack.addArrangedSubview(horizontalStack)
                horizontalStack.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            }

        }

        if style.closable {
            let closeButton = PizzaButton(primaryAction: .init(handler: { _ in
                SwiftEntryKit.dismiss()
            }))
            closeButton.setImage(
                UIImage(
                    systemSymbol: .xmarkCircleFill,
                    withConfiguration: UIImage.SymbolConfiguration(
                        hierarchicalColor: .palette.labelSecondary
                    ).applying(UIImage.SymbolConfiguration(pointSize: 22))
                ),
                for: []
            )
            addSubview(closeButton)
            closeButton.tintColor = .systemGray4
            closeButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.size.equalTo(60)
            }
        }
    }

    private func getViewSeparator(height: CGFloat) -> UIView {
        UIView().do {
            $0.snp.makeConstraints { make in
                make.height.equalTo(height)
                make.width.equalTo(1)
            }
        }
    }

}
