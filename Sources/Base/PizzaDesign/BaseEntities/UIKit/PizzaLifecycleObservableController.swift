import PizzaCore

public protocol PizzaLifecycleObservableController {

    func onDidAppear(completion: @escaping PizzaEmptyClosure)
    func onWillAppear(completion: @escaping PizzaEmptyClosure)
    func onWillDisappear(completion: @escaping PizzaEmptyClosure)
    func onDidDisappear(completion: @escaping PizzaEmptyClosure)
    func onDidLoad(completion: @escaping PizzaEmptyClosure)

}
