import PizzaKit

public protocol PizzaDesignSystemUICoordinatable: AnyObject {
    func moduleWasDeallocated()
    func openComponents()
    func openLabelStyles()
    func openColors()
    func openButtons()
    func openPopups()
}

public class PizzaDesignSystemUICoordinator<Deeplink>: PizzaRouterCoordinator<Deeplink>, PizzaDesignSystemUICoordinatable {

    public override func start() {
        let presenter = MenuPresenter(coordinator: self)
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    // MARK: - PizzaDesignSystemUICoordinatable

    public func moduleWasDeallocated() {
        onFinish?()
    }

    public func openComponents() {
        let presenter = ComponentsPresenter()
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    public func openLabelStyles() {
        let presenter = LabelStylesPresenter()
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    public func openColors() {
        let presenter = ColorsPresenter()
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    public func openButtons() {
        let presenter = ButtonsPresenter()
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    public func openPopups() {
        let presenter = PopupPresenter()
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

}
