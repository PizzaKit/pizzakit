import PizzaCore
import UIKit

public protocol ControllerWithScrollView: UIViewController {
    var scrollView: UIScrollView { get }
}

public protocol ComponentPresenterDelegate: AnyObject {
    var controller: ControllerWithScrollView { get }
    func render(sections: [ComponentSection])
}

public protocol ComponentPresenter: AnyObject {
    var delegate: ComponentPresenterDelegate? { get set }
    func touch()
}
