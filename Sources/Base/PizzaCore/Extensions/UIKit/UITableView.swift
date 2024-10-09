import UIKit

public extension UITableView {

    // MARK: - Registration

    /// Method for easy registering cell
    func register<T: UITableViewCell>(_ class: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: `class`))
    }

    /// Method for easy dequeuing cell
    func dequeueReusableCell<T: UITableViewCell>(
        withClass class: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: `class`), for: indexPath
        ) as? T else {
            fatalError("unable to dequeue table cell with class: \(`class`)")
        }
        return cell
    }

    /// Method for easy registering header/footer view
    func register<T: UITableViewHeaderFooterView>(_ class: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: `class`))
    }

    /// Method for easy dequeuing header/footer
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        withClass class: T.Type
    ) -> T {
        guard let view = dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: `class`)
        ) as? T else {
            fatalError("unable to dequeue table header/footer view with class: \(`class`)")
        }
        return view
    }

}
