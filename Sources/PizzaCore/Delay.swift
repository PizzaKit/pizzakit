import Foundation

/// Wrapper for DispatchQueue with easy delay param
public func delay(seconds: TimeInterval, closure: @escaping PizzaEmptyClosure) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        closure()
    }
}
