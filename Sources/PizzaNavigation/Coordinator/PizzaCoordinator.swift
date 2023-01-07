/// Entity for navigating inside feature flows
public protocol PizzaCoordinator<Deeplink>: AnyObject, PizzaDeeplinking {

    associatedtype Deeplink

    /// Method for starting coordinator
    func start()

}
