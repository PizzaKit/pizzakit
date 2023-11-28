import PizzaDesign
import PizzaCore
import UIKit

open class ComponentTableController: PizzaTableController, ComponentPresenterDelegate, ControllerWithScrollView {

    // MARK: - Properties

    public let presenter: ComponentPresenter
    public let updater = TableViewUpdater()

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

    public func getCell(componentId: AnyHashable) -> UIView? {
        updater.getCell(tableView: tableView, componentId: componentId)
    }

    // MARK: - ControllerWithScrollView

    public var scrollView: UIScrollView {
        tableView
    }

}
