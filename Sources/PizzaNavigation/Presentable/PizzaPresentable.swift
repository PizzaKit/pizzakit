import UIKit

/// Describes object that can be presented in view hierarchy
public protocol PizzaPresentable: AnyObject {
    func toPresent() -> UIViewController
}

extension UIViewController: PizzaPresentable {

    public func toPresent() -> UIViewController {
        return self
    }

}
