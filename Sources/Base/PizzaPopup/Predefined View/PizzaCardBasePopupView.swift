import UIKit
import PizzaCore
import PizzaDesign
import PizzaIcon

open class PizzaCardBasePopupView: PizzaView, PizzaCardPopupViewOrController {

    public var onClosed = PizzaCardPopupCloseFireWrapper()

    private var presenter: PizzaCardPopupPresenter?
    public func configure(presenter: PizzaCardPopupPresenter) {
        self.presenter = presenter
        self.presenter?.delegate = self
    }

    private let info: PizzaCardPopupInfo
    private let style: PizzaCardPopupInfoStyle
    private let beforeButtonView: UIView?

    public init(
        info: PizzaCardPopupInfo,
        style: PizzaCardPopupInfoStyle,
        beforeButtonView: UIView? = nil
    ) {
        self.info = info
        self.style = style
        self.beforeButtonView = beforeButtonView
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        onClosed.callCompletionJustOnce()
    }

    open override func commonInit() {
        super.commonInit()

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
                stack.addArrangedSubview(view)
            case .image(let image):
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.snp.makeConstraints { make in
                    make.size.equalTo(style.imageSize ?? .init(side: 96))
                }
                imageView.tintColor = style.imageTintColor
                stack.addArrangedSubview(imageView)
            case .sfSymbol(let symbol):
                let pizzaIconView = PizzaIconView()
                    .do {
                        $0.configure(
                            icon: .init(sfSymbol: symbol)
                                .apply(preset: .teaserDimmedBGColoredLarge, color: style.imageTintColor),
                            shouldBounce: true
                        )
                    }
                stack.addArrangedSubview(pizzaIconView)
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
                    getViewSeparator(height: style.descriptionToBeforeButtonOffset)
                )
            }

            if let beforeButtonView = beforeButtonView {
                stack.addArrangedSubview(beforeButtonView)
                beforeButtonView.snp.makeConstraints { make in
                    make.width.equalTo(stack)
                }
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
                    let button = UIButton(primaryAction: .init(handler: { [weak self] _ in
                        let needClose = self?.presenter?
                            .needClosePopup(buttonId: buttonInfo.id) ?? true
                        let needButtonAction = self?.presenter?
                            .needButtonAction(buttonId: buttonInfo.id) ?? true
                        if needButtonAction {
                            buttonInfo.action?()
                        }
                        if needClose {
                            self?.onClosed
                                .fill(closeType: .onActionButton(buttonId: buttonInfo.id))
                            PizzaCardPopup.dismiss {
                                self?.onClosed.callCompletionJustOnce()
                            }
                        }
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
                    let button = UIButton(primaryAction: .init(handler: { [weak self] _ in
                        let needClose = self?.presenter?
                            .needClosePopup(buttonId: buttonInfo.id) ?? true
                        let needButtonAction = self?.presenter?
                            .needButtonAction(buttonId: buttonInfo.id) ?? true
                        if needButtonAction {
                            buttonInfo.action?()
                        }
                        if needClose {
                            self?.onClosed
                                .fill(closeType: .onActionButton(buttonId: buttonInfo.id))
                            PizzaCardPopup.dismiss {
                                self?.onClosed.callCompletionJustOnce()
                            }
                        }
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
