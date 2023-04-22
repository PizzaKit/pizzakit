import PizzaDesign
import PizzaCore
import UIKit

open class ComponentTableController: UITableViewController, ComponentPresenterDelegate, ControllerWithScrollView {

    // MARK: - Properties

    private let presenter: ComponentPresenter
    private let updater = TableViewUpdater()

    private var prevData: [ComponentSection] = []

    // MARK: - Initialization

    public init(presenter: ComponentPresenter) {
        self.presenter = presenter
        super.init(style: .insetGrouped)

        presenter.delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorInsetReference = .fromAutomaticInsets

        updater.initialize(target: tableView)
        presenter.touch()

        updater.performUpdates(target: tableView, sections: prevData)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updater.performUpdates(target: tableView, sections: prevData)
    }

    // MARK: - ComponentPresenterDelegate

    public var controller: ControllerWithScrollView { self }

    public func render(sections: [ComponentSection]) {
        if isViewLoaded {
            updater.performUpdates(target: tableView, sections: sections)
        }
        prevData = sections
    }

    // MARK: - ControllerWithScrollView

    public var scrollView: UIScrollView {
        tableView
    }

}
