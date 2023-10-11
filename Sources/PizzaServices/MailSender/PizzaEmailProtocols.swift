import Foundation
import UIKit

public enum PizzaEmailServiceError: LocalizedError {
    case thereIsNoAbilityToSendMail
    case system(Error)
}

public protocol PizzaEmailErrorHandler {

    func handle(error: PizzaEmailServiceError)

}

public protocol PizzaEmailRouter {

    func emailPresent(_ viewController: UIViewController)

    func emailDismiss()

}
