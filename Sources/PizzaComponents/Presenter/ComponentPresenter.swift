import PizzaCore
import PizzaDesign
import UIKit

public protocol ControllerWithScrollView: UIViewController, PizzaLifecycleObservableController {
    var scrollView: UIScrollView { get }
}

public protocol ComponentPresenterDelegate: AnyObject {
    var controller: ControllerWithScrollView { get }
    func render(sections: [ComponentSection])
    func getCell(componentId: AnyHashable) -> UIView?
}

public protocol ComponentPresenter: AnyObject {
    var delegate: ComponentPresenterDelegate? { get set }
    func touch()
}
