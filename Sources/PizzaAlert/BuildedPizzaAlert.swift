import UIKit
import PizzaCore

/// Entity for showing alertController
open class BuildedPizzaAlert {

    private let alertController: UIViewController

    init(alertController: UIViewController) {
        self.alertController = alertController
    }

    open func show() {
        let configController = PizzaAlertConfiguration.customControllerToPresentClosure?(())
        let rootController = UIApplication.keyWindow?.rootViewController
        show(over: configController ?? rootController)
    }

    open func show(over controller: UIViewController?) {
        controller?.present(alertController, animated: true)
    }

}
