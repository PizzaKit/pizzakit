import UIKit
import PizzaDesign
import PizzaCore

open class ComponentWrapperTableController: PizzaController, ControllerWithScrollView, ComponentPresenterDelegate {

    // MARK: - Private Properties

    public let tableController: ComponentTableController

    // MARK: - Initialization

    public init(presenter: ComponentPresenter) {
        tableController = .init(presenter: presenter)

        super.init()

        presenter.delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        addChild(tableController)
        view.addSubview(tableController.view)
        tableController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableController.didMove(toParent: self)
    }

    public var scrollView: UIScrollView {
        tableController.scrollView
    }

    public var controller: ControllerWithScrollView {
        self
    }

    open func render(sections: [ComponentSection]) {
        tableController.render(sections: sections)
    }

    public func getCell(componentId: AnyHashable) -> UIView? {
        tableController.getCell(componentId: componentId)
    }

    public func updaterDelegate(_ updaterDelegate: UpdaterDelegate) {
        tableController.updaterDelegate(updaterDelegate)
    }

}
