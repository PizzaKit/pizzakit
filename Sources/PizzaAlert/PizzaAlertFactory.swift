import UIKit

/// Factory for alert
public protocol PizzaAlertFactory {
    func produce(with alert: PizzaAlert) -> UIViewController
}
