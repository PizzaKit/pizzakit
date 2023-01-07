import UIKit

public extension UIViewController {

    func traverseAndFindClass<T: UIViewController>() -> T? {
        var currentVC = self
        while let parentVC = currentVC.parent {
            if let result = parentVC as? T {
                return result
            }
            currentVC = parentVC
        }
        return nil
    }

}
