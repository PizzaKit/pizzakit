import UIKit
import SwiftUI
import PizzaKit
import SnapKit
import SFSafeSymbols
import PizzaIcon

public struct PizzaBlockingScreenView: View {

    private enum Constants {
        static let maxWidth: CGFloat = PizzaDesignConstants.maxSmallWidth
        static let imageMaxWidth: CGFloat = 300
        static let plainButtonHeight: CGFloat = 50
        static let sfSymbolFontSize: CGFloat = 100
        static let spacingHeigh: CGFloat = 18
        static let appIconSize: CGFloat = 100
    }

    public let model: PizzaBlockingScreenModel
    public let onButtonPress: PizzaEmptyClosure
    public let onClosePress: PizzaEmptyClosure

    public init(
        model: PizzaBlockingScreenModel,
        onButtonPress: @escaping PizzaEmptyClosure,
        onClosePress: @escaping PizzaEmptyClosure
    ) {
        self.model = model
        self.onButtonPress = onButtonPress
        self.onClosePress = onClosePress
    }

    @ViewBuilder
    public var imageView: some View {
        if
            let appIconImage = model.icon.appIconImage 
        {
            Image(uiImage: appIconImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: Constants.appIconSize,
                    height: Constants.appIconSize
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: Constants.appIconSize * 0.23
                    )
                )
        } else if
            let pizzaIcon = model.icon.pizzaIcon
        {
            PizzaSUIIconView(icon: pizzaIcon, shouldBounce: true)
        } else if
            let assetImage = model.icon.assetImage
        {
            Image(uiImage: assetImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: Constants.imageMaxWidth)
        }
    }

    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    imageView

                    Spacer()
                        .frame(height: min(max(geometry.size.height / 18, 12), 50))

                    Text(
                        model.title
                            .split(symbol: "|")
                            .map { part in
                                var str = AttributedString(part.string)
                                str.font = .title.weight(.bold)
                                str.foregroundColor = {
                                    if part.isInside {
                                        return .accentColor
                                    }
                                    return .primary
                                }()
                                return str
                            }
                        .reduce(AttributedString(), { partialResult, current in
                            partialResult + current
                        })
                    )
                    .multilineTextAlignment(.center)

                    if let desc = model.desc {
                        Spacer()
                            .frame(height: Constants.spacingHeigh)

                        Text(desc)
                            .font(.system(size: 17))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                        .frame(height: Constants.spacingHeigh)

                    Spacer()

                    if let button = model.button {
                        Button {
                            onButtonPress()
                        } label: {
                            Text(button.title)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonBorderShape(.roundedRectangle(radius: 14))
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .font(.system(size: 17, weight: .semibold))
                    }

                    if let closeName = model.closeButtonName {
                        Button {
                            onClosePress()
                        } label: {
                            Text(closeName)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderless)
                        .foregroundStyle(.tint)
                        .font(.system(size: 17, weight: .semibold))
                        .controlSize(.large)
                        .frame(minHeight: Constants.plainButtonHeight)
                    }
                }
                .padding()
                .frame(maxWidth: Constants.maxWidth)
                .frame(maxWidth: .infinity)
            }
        }

    }
}

public struct PizzaBlockingScreenModel {

    public struct ButtonActionContext: Codable {
        public let url: String
        public let closeAfterOpeningURL: Bool

        public init(url: String, closeAfterOpeningURL: Bool) {
            self.url = url
            self.closeAfterOpeningURL = closeAfterOpeningURL
        }
    }

    public struct Button {
        public let title: String
        public let actionContext: ButtonActionContext

        public init(title: String, actionContext: ButtonActionContext) {
            self.title = title
            self.actionContext = actionContext
        }
    }

    public struct Icon {
        public let pizzaIcon: PizzaIcon?
        public let assetImage: UIImage?
        public let appIconImage: UIImage?

        public init(pizzaIcon: PizzaIcon?, assetImage: UIImage?, appIconImage: UIImage?) {
            self.pizzaIcon = pizzaIcon
            self.assetImage = assetImage
            self.appIconImage = appIconImage
        }
    }

    public let title: String
    public let desc: String?
    public let icon: Icon
    public let button: Button?
    public let closeButtonName: String?

    public init(
        title: String,
        desc: String?,
        icon: Icon,
        button: Button?,
        closeButtonName: String?
    ) {
        self.title = title
        self.desc = desc
        self.icon = icon
        self.button = button
        self.closeButtonName = closeButtonName
    }

}

public protocol PizzaBlockingScreenControllerDelegate: AnyObject {
    func closeModule()
    func open(
        url: URL,
        closeAfterOpeningURL: Bool
    )
}

open class PizzaBlockingScreenController: PizzaController {

    private let hostingController: UIHostingController<PizzaBlockingScreenView>
    private weak var delegate: PizzaBlockingScreenControllerDelegate?

    private let buttonActionContext: PizzaBlockingScreenModel.ButtonActionContext?

    public init(
        model: PizzaBlockingScreenModel,
        delegate: PizzaBlockingScreenControllerDelegate?
    ) {
        var onButtonPress: PizzaEmptyClosure?
        var onClosePress: PizzaEmptyClosure?
        let view = PizzaBlockingScreenView(
            model: model,
            onButtonPress: {
                onButtonPress?()
            },
            onClosePress: {
                onClosePress?()
            }
        )
        self.hostingController = .init(
            rootView: view
        )
        self.buttonActionContext = model.button?.actionContext
        self.delegate = delegate
        super.init()

        onButtonPress = { [weak self] in
            self?.handleButtonPress()
        }
        onClosePress = { [weak self] in
            self?.delegate?.closeModule()
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(delegate: PizzaBlockingScreenControllerDelegate) {
        self.delegate = delegate
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hostingController.didMove(toParent: self)
    }

    private func handleButtonPress() {
        guard let buttonActionContext else { return }
        guard let url = URL(string: buttonActionContext.url) else {
            PizzaLogger.log(
                label: "blocking_screen",
                level: .error,
                message: "URL from context in not constructed: \(buttonActionContext.url)"
            )
            return
        }
        delegate?.open(
            url: url,
            closeAfterOpeningURL: buttonActionContext.closeAfterOpeningURL
        )
    }

}

struct BlockingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        PizzaBlockingScreenView(
            model: .init(
                title: "Требуется обновление |NAME OF APP|",
                desc: "Чтобы продолжить пользоваться приложением, обновите это приложение в AppStore",
                icon: .init(
                    pizzaIcon: .init(sfSymbolRaw: "gear.badge.questionmark")?
                        .apply(
                            preset: .teaserDimmedBGColoredLarge,
                            color: .tintColor
                        ),
                    assetImage: nil,
                    appIconImage: nil
                ),
                button: .init(
                    title: "Обновить",
                    actionContext: .init(url: "", closeAfterOpeningURL: true)
                ),
                closeButtonName: "Позже"
            ),
            onButtonPress: {},
            onClosePress: {}
        )
    }
}
