import UIKit
import PizzaCore

public enum PizzaEmailServiceError: LocalizedError {
    case thereIsNoAbilityToSendMail
    case system(Error)
}

public enum PizzaEmailServiceAction {
    case present(UIViewController)
    case doNothing
}

public struct PizzaEmailServiceHandlers {
    let onDismiss: PizzaEmptyClosure
    let onError: PizzaClosure<PizzaEmailServiceError>

    public init(
        onDismiss: @escaping PizzaEmptyClosure,
        onError: @escaping PizzaClosure<PizzaEmailServiceError>
    ) {
        self.onDismiss = onDismiss
        self.onError = onError
    }
}

public protocol PizzaEmailService {
    func canSend() -> Bool
    func send(payload: PizzaEmailPayload) -> PizzaEmailServiceAction
}

public final class PizzaEmailServiceImpl: PizzaEmailService {

    // MARK: - Nested Types

    private enum EmailSendType {
        case insideApp
        case defaultAppMail
    }

    // MARK: - Private Properties

    private let handlers: PizzaEmailServiceHandlers

    // MARK: - Initializaion

    public init(handlers: PizzaEmailServiceHandlers) {
        self.handlers = handlers
    }

    // MARK: - Public Methods

    public func canSend() -> Bool {
        return getMailSendType() != nil
    }

    public func send(
        payload: PizzaEmailPayload
    ) -> PizzaEmailServiceAction {
        switch getMailSendType() {
        case .insideApp:
            return .present(openInsideApp(payload: payload))
        case .defaultAppMail:
            openDefaultAppMail(payload: payload)
            return .doNothing
        case .none:
            handlers.onError(.thereIsNoAbilityToSendMail)
            return .doNothing
        }
    }

    // MARK: - Private Methods

    private func getMailSendType() -> EmailSendType? {
        if canSendInsideApp() {
            return .insideApp
        }
        if canSendInDefaultAppMail() {
            return .defaultAppMail
        }
        return nil
    }

    private func canSendInsideApp() -> Bool {
        return PizzaMailController.canSendMail()
    }

    private func openInsideApp(payload: PizzaEmailPayload) -> UIViewController {
        let viewController = PizzaMailController()
        viewController.setupInitialState(
            recipient: payload.recipient,
            subject: payload.subject,
            body: payload.body
        )
        viewController.onClose = { [weak self] optionalError in
            guard let error = optionalError else {
                self?.handlers.onDismiss()
                return
            }
            self?.handlers.onError(.system(error))
        }
        return viewController
    }

    private func canSendInDefaultAppMail() -> Bool {
        guard let url = URL(string: "mailto:some@mail.ru") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    private func openDefaultAppMail(payload: PizzaEmailPayload) {
        let subjectEncoded = payload.subject?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let bodyEncoded = payload.body?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""

        guard
            let mailUrl = URL(string: "mailto:\(payload.recipient)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        else {
            return
        }

        UIApplication.shared.open(mailUrl)
    }

}
