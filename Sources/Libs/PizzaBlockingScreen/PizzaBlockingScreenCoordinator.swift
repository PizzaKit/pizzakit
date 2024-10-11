import UIKit
import XCoordinator
import PizzaKit

public enum PizzaBlockingCloseType {
    case closeButton
    case actionButton
}

public struct PizzaBlockingClosePayload {
    public let closeType: PizzaBlockingCloseType
    public let completion: PizzaEmptyClosure?
}

public enum PizzaBlockingRoute: Route {
    case open(url: URL, closeAfterOpeningURL: Bool)
    case close
}

public class PizzaBlockingScreenCoordinator: BaseCoordinator<PizzaBlockingRoute, XCoordinator.Transition<UIViewController>>,
                                 PizzaBlockingScreenControllerDelegate {

    private let resourcesBundle: Bundle
    private let blockingControllerModification: PizzaClosure<UIViewController & PizzaLifecycleObservableController>?
    private let onClose: PizzaClosure<PizzaBlockingClosePayload>

    public init(
        blockingSettings: PizzaBlockingScreenRemoteSettings,
        resourcesBundle: Bundle,
        blockingControllerModification: PizzaClosure<UIViewController & PizzaLifecycleObservableController>?,
        onClose: @escaping PizzaClosure<PizzaBlockingClosePayload>
    ) {
        self.resourcesBundle = resourcesBundle
        self.blockingControllerModification = blockingControllerModification
        self.onClose = onClose
        let controller = PizzaBlockingScreenController(
            model: .init(
                title: blockingSettings.title,
                desc: blockingSettings.desc,
                icon: .init(
                    pizzaIcon: {
                        if
                            let systemName = blockingSettings.icon.sfSymbol
                        {
                            return .init(sfSymbolRaw: systemName)?
                                .apply(
                                    preset: .teaserDimmedBGColoredLarge,
                                    color: .tintColor
                                )
                        }
                        return nil
                    }(),
                    assetImage: {
                        if
                            let assetName = blockingSettings.icon.assetName,
                            let image = UIImage(
                                named: assetName,
                                in: resourcesBundle,
                                with: nil
                            )
                        {
                            return image
                        } else if
                            let assetName = blockingSettings.icon.assetName,
                            let image = UIImage(
                                named: assetName,
                                in: Bundle.main,
                                with: nil
                            )
                        {
                            return image
                        }
                        return nil
                    }(),
                    appIconImage: {
                        if let appIconName = blockingSettings.icon.appIconName {
                            return UIImage(named: appIconName, in: .main, with: nil)
                        }
                        return nil
                    }()
                ),
                button: blockingSettings.button.map {
                    .init(
                        title: $0.title,
                        actionContext: .init(
                            url: $0.actionContext.url,
                            closeAfterOpeningURL: $0.actionContext.closeAfterOpeningURL
                        )
                    )
                },
                closeButtonName: blockingSettings.closeButtonName
            ),
            delegate: nil
        )
        blockingControllerModification?(controller)
        super.init(
            rootViewController: controller,
            initialRoute: nil
        )
        controller.configure(delegate: self)
    }

    override public func prepareTransition(for route: PizzaBlockingRoute) -> Transition<UIViewController> {
        switch route {
        case .open(let url, let closeAfterOpeningURL):
            if closeAfterOpeningURL {
                onClose(
                    .init(
                        closeType: .actionButton,
                        completion: {
                            UIApplication.shared.open(url)
                        }
                    )
                )
                return .none()
            }
            UIApplication.shared.open(url)
            return .none()
        case .close:
            onClose(
                .init(
                    closeType: .closeButton,
                    completion: nil
                )
            )
            return .none()
        }
    }

    // MARK: - PizzaBlockingScreenControllerDelegate

    public func closeModule() {
        strongRouter.trigger(.close)
    }

    public func open(url: URL, closeAfterOpeningURL: Bool) {
        strongRouter.trigger(.open(url: url, closeAfterOpeningURL: closeAfterOpeningURL))
    }

}
