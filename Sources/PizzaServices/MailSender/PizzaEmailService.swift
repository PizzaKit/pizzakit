import UIKit

public protocol PizzaEmailService {
    func canSend() -> Bool
    func send(payload: PizzaEmailPayload)
}

public final class PizzaEmailServiceImpl: PizzaEmailService {

    // MARK: - Nested Types

    private enum EmailSendType {
        case insideApp
        case defaultAppMail
    }

    // MARK: - Private Properties

    private let errorHandler: PizzaEmailErrorHandler
    private let router: PizzaEmailRouter

    // MARK: - Initializaion

    public init(
        errorHandler: PizzaEmailErrorHandler,
        router: PizzaEmailRouter
    ) {
        self.errorHandler = errorHandler
        self.router = router
    }

    // MARK: - Public Methods

    public func canSend() -> Bool {
        return getMailSendType() != nil
    }

    public func send(payload: PizzaEmailPayload) {
        switch getMailSendType() {
        case .insideApp:
            openInsideApp(payload: payload)
        case .defaultAppMail:
            openDefaultAppMail(payload: payload)
        case .none:
            errorHandler.handle(error: .thereIsNoAbilityToSendMail)
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

    private func openInsideApp(payload: PizzaEmailPayload) {
        let viewController = PizzaMailController()
        viewController.setupInitialState(
            recipient: payload.recipient,
            subject: payload.subject,
            body: payload.body
        )
        viewController.onClose = { optionalError in
            guard let error = optionalError else {
                self.router.emailDismiss()
                return
            }
            self.errorHandler.handle(error: .system(error))
        }
        router.emailPresent(viewController)
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
