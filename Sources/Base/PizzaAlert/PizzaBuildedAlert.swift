import UIKit
import PizzaCore
import PizzaNavigation

/// Entity for showing alertController
open class PizzaBuildedAlert {

    private let alertController: UIViewController

    init(alertController: UIViewController) {
        self.alertController = alertController
    }

    open func show() {
        let configController = PizzaAlertConfiguration.customControllerToPresentClosure?(())
        let rootController = UIApplication.keyWindow?.rootViewController
        let topController = UIApplication.topViewController(rootController)
        show(over: configController ?? topController)
    }

    open func show(over controller: UIViewController?) {
        controller?.present(alertController, animated: true)
    }

}
