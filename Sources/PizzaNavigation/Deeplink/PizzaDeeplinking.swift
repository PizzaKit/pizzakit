/// Entity for handle deeplink
public protocol PizzaDeeplinking<Deeplink>: AnyObject {

    associatedtype Deeplink

    /// Method for handling deeplink
    /// - Returns: `true` if coordinator handled current deeplink, `false` otherwise
    @discardableResult
    func handle(deeplink: Deeplink) -> Bool

}
