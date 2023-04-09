import PizzaKit
import UIKit
import Combine

public protocol FormPresenterDelegate: AnyObject {
    func render(sections: [Section])
}

public protocol FormPresenter: AnyObject {
    var delegate: FormPresenterDelegate? { get set }
    func touch()
}

open class FormTableController: UITableViewController, FormPresenterDelegate {

    // MARK: - Properties

    private let presenter: FormPresenter
    private let updater = TableViewUpdater()
    private let onViewDidLoad: PizzaClosure<UITableViewController>?

    // MARK: - Initialization

    public init(
        presenter: FormPresenter,
        onViewDidLoad: PizzaClosure<UITableViewController>?
    ) {
        self.presenter = presenter
        self.onViewDidLoad = onViewDidLoad
        super.init(style: .insetGrouped)

        presenter.delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()

        onViewDidLoad?(self)

        updater.initialize(target: tableView)
        presenter.touch()
    }

    // MARK: - FormPresenterDelegate

    public func render(sections: [Section]) {
        updater.performUpdates(target: tableView, data: sections)
    }

}
