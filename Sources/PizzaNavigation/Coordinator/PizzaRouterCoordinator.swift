import Foundation
import PizzaCore

/// Realization of coordinator with router
open class PizzaRouterCoordinator<Deeplink>: PizzaCoordinator {

    // MARK: - Properties

    public private(set) var children: [PizzaRouterCoordinator] = []
    public private(set) weak var parent: PizzaRouterCoordinator?
    public private(set) var router: PizzaRouter!

    /// Need to call when such flow is not needed
    /// (for example on deinit root controller for current coordinator)
    public var onFinish: PizzaEmptyClosure?

    // MARK: - Initialization

    public init() {}

    // MARK: - Methods

    open func start() {}

    @discardableResult
    open func handle(deeplink: Deeplink) -> Bool {
        for child in children {
            if child.handle(deeplink: deeplink) {
                return true
            }
        }
        return false
    }

    /// Method for checking if passed coordinator exists in children recursively
    open func checkDependencyExistsRecursively<T: PizzaRouterCoordinator<Deeplink>>(
        ofType coordinatorType: T.Type
    ) -> Bool {
        for child in children {
            if
                child.checkDependencyExistsRecursivelyWithCheckOfSelf(
                    ofType: coordinatorType
                )
            {
                return true
            }
        }
        return false
    }

    /// Method for checking if passed coordinator exists in children
    open func checkDependencyExists<T: PizzaRouterCoordinator<Deeplink>>(
        ofType coordinatorType: T.Type
    ) -> Bool {
        return children.first(where: { coordinator in
            type(of: coordinator) == coordinatorType
        }) != nil
    }

    /// Method for adding dependency
    @discardableResult
    open func addDependency<T: PizzaRouterCoordinator<Deeplink>>(
        coordinator: T
    ) -> T {
        let newCoordinator = coordinator
        newCoordinator.fill(router: router)
        newCoordinator.parent = self
        newCoordinator.onFinish = { [weak self, weak newCoordinator] in
            self?.removeDependency(newCoordinator)
        }
        children.append(newCoordinator)
        newCoordinator.start()
        return newCoordinator
    }

    /// Method for adding router for coordinator. Called automatically
    /// inside `addDependency` method. For root coordinator this method must be called
    /// manually.
    open func fill(router: PizzaRouter) {
        self.router = router
    }

    // MARK: - Private Methods

    private func removeDependency(_ coordinator: PizzaRouterCoordinator<Deeplink>?) {
        children.removeAll(where: { $0 === coordinator })
    }

    private func checkDependencyExistsRecursivelyWithCheckOfSelf<T: PizzaRouterCoordinator<Deeplink>>(
        ofType coordinatorType: T.Type
    ) -> Bool {
        for child in children {
            let isExist = child.checkDependencyExistsRecursively(ofType: coordinatorType)
            if isExist {
                return true
            }
        }
        if type(of: self) == coordinatorType {
            return true
        }
        return false
    }

}
