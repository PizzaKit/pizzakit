import UIKit
import PizzaCore

/// Configuration for `PizzaAlert` module
public enum PizzaAlertConfiguration {

    /// Change it if need custom factory
    public static var factory: PizzaAlertFactory = PizzaNativeAlertFactory()

    /// Change it for custom cancel text (better with localization)
    public static var defaultCancelText = "Cancel"

    /// Method for getting controller, from which alert should be presented
    public static var customControllerToPresentClosure: PizzaReturnClosure<Void, UIViewController>?

}
