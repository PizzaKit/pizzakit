//import UIKit
//import PizzaKit
//
//public protocol PizzaFormRenderable: AnyObject {
//    func render(form: PizzaForm)
//}
//
//open class PizzaFormController: UITableViewController, PizzaFormRenderable {
//
//    // MARK: - Private Properties
//
//    private let interactor: PizzaFormInteractor
//    private lazy var adapter = PizzaFormAdapter(tableView: tableView)
//
//    // MARK: - Initialization
//
//    public init(interactor: PizzaFormInteractor) {
//        self.interactor = interactor
//        super.init(style: .insetGrouped)
//    }
//
//    required public init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - UIViewController
//
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        interactor.touch()
//    }
//
//    // MARK: - PizzaFormRenderable
//
//    public func render(form: PizzaForm) {
//        adapter.configure(sections: form.sections)
//    }
//
//}
