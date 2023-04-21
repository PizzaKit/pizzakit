import PizzaDesign
import PizzaCore
import UIKit
import Combine

public protocol FormPresenterDelegate: AnyObject {
    func modify(controller: PizzaClosure<FormTableController>)
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

    private var prevData: [Section] = []

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

        updater.performUpdates(target: tableView, data: prevData)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updater.performUpdates(target: tableView, data: prevData)
    }

    // MARK: - FormPresenterDelegate

    public func render(sections: [Section]) {
        if isViewLoaded {
            updater.performUpdates(target: tableView, data: sections)
        }
        prevData = sections
    }

    public func modify(controller: (FormTableController) -> Void) {
        controller(self)
    }

}
