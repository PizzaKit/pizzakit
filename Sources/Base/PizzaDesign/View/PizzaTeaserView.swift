import UIKit
import PizzaCore
import SnapKit
import SFSafeSymbols

// TODO: add PizzaIcon
public struct PizzaTeaserInfo {

    public enum ImageType {
        case customView(UIView)
        case image(UIImage)
    }

    public enum ButtonType {
        case primary
        case secondary
        case errorPrimary
        case errorSecondary
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

public struct PizzaTeaserInfoStyle {

    public enum ButtonAxis {
        case vertical
        case horizontal
    }

    public let contentToViewInsets: UIEdgeInsets
    /// Если картинка будет иметь тип `.customView` размер не будет выставляться
    public let imageSize: CGSize?
    public let imageToTitleOffset: CGFloat
    public let titleToDescriptionOffset: CGFloat
    public let descriptionToButtonOffset: CGFloat
    public let betweenButtonsOffset: CGFloat
    public let titleStyle: UIStyle<PizzaLabel>
    public let descriptionStyle: UIStyle<PizzaLabel>
    public let primaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let secondaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let errorPrimaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let errorSecondaryButtonStyleProvider: PizzaReturnClosure<String, UIStyle<UIButton>>
    public let buttonAxis: ButtonAxis

    public init(
        contentToViewInsets: UIEdgeInsets,
        imageSize: CGSize?,
        imageToTitleOffset: CGFloat,
        titleToDescriptionOffset: CGFloat,
        descriptionToButtonOffset: CGFloat,
        betweenButtonsOffset: CGFloat,
        titleStyle: UIStyle<PizzaLabel>,
        descriptionStyle: UIStyle<PizzaLabel>,
        primaryButtonStyleProvider: @escaping PizzaReturnClosure<String, UIStyle<UIButton>>,
        secondaryButtonStyleProvider: @escaping PizzaReturnClosure<String, UIStyle<UIButton>>,
        errorPrimaryButtonStyleProvider: @escaping PizzaReturnClosure<String, UIStyle<UIButton>>,
        errorSecondaryButtonStyleProvider: @escaping PizzaReturnClosure<String, UIStyle<UIButton>>,
        buttonAxis: ButtonAxis
    ) {
        self.contentToViewInsets = contentToViewInsets
        self.imageSize = imageSize
        self.imageToTitleOffset = imageToTitleOffset
        self.titleToDescriptionOffset = titleToDescriptionOffset
        self.descriptionToButtonOffset = descriptionToButtonOffset
        self.betweenButtonsOffset = betweenButtonsOffset
        self.titleStyle = titleStyle
        self.descriptionStyle = descriptionStyle
        self.primaryButtonStyleProvider = primaryButtonStyleProvider
        self.secondaryButtonStyleProvider = secondaryButtonStyleProvider
        self.errorPrimaryButtonStyleProvider = errorPrimaryButtonStyleProvider
        self.errorSecondaryButtonStyleProvider = errorSecondaryButtonStyleProvider
        self.buttonAxis = buttonAxis
    }

    public static func `default`(
        buttonAxis: ButtonAxis
    ) -> PizzaTeaserInfoStyle {
        PizzaTeaserInfoStyle(
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
                return .allStyles.standard(
                    title: title,
                    size: .large,
                    type: .primary
                )
            },
            secondaryButtonStyleProvider: { title in
                return .allStyles.standard(
                    title: title,
                    size: .large,
                    type: .secondary
                )
            },
            errorPrimaryButtonStyleProvider: { title in
                return .allStyles.standard(
                    title: title,
                    size: .large,
                    type: .error
                )
            },
            errorSecondaryButtonStyleProvider: { title in
                return .allStyles.standard(
                    title: title,
                    size: .large,
                    type: .errorTertiary
                )
            },
            buttonAxis: buttonAxis
        )
    }

}

public class PizzaTeaserView: PizzaView {

    private let info: PizzaTeaserInfo
    private let style: PizzaTeaserInfoStyle

    public init(
        info: PizzaTeaserInfo,
        style: PizzaTeaserInfoStyle
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

        UIStackView().do { stack in
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .center
            stack.spacing = 0

            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                    .inset(style.contentToViewInsets)
                make.top.greaterThanOrEqualToSuperview()
                    .offset(style.contentToViewInsets.top)
                make.bottom.lessThanOrEqualToSuperview()
                    .offset(-style.contentToViewInsets.bottom)
                make.centerY.equalToSuperview()
            }

            // image
            switch info.image {
            case .customView(let view):
                stack.addArrangedSubview(view)
            case .image(let image):
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
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
                    case .errorPrimary:
                        button.apply(style: style.errorPrimaryButtonStyleProvider(buttonInfo.title))
                    case .errorSecondary:
                        button.apply(style: style.errorSecondaryButtonStyleProvider(buttonInfo.title))
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
                    case .errorPrimary:
                        button.apply(style: style.errorPrimaryButtonStyleProvider(buttonInfo.title))
                    case .errorSecondary:
                        button.apply(style: style.errorSecondaryButtonStyleProvider(buttonInfo.title))
                    }
                    horizontalStack.addArrangedSubview(button)
                }
                stack.addArrangedSubview(horizontalStack)
                horizontalStack.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
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

public class PizzaTeaserController: PizzaController {

    // MARK: - Properties

    private let teaserView: PizzaTeaserView

    // MARK: - Initialization

    public init(
        info: PizzaTeaserInfo,
        style: PizzaTeaserInfoStyle = .default(buttonAxis: .vertical)
    ) {
        self.teaserView = .init(
            info: info,
            style: style
        )
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .palette.background
        teaserView.do {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            }
        }
    }

}

