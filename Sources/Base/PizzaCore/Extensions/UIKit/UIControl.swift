import UIKit

private var trampolineContext: UInt8 = 0

public protocol UIControlActionFunctionProtocol {}
extension UIControl: UIControlActionFunctionProtocol {}
public extension UIControlActionFunctionProtocol where Self: UIControl {
    func on(events: UIControl.Event, do action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        addTarget(trampoline, action: #selector(trampoline.action(sender:)), for: events)
        objc_setAssociatedObject(
            self,
            &trampolineContext,
            trampoline,
            .OBJC_ASSOCIATION_RETAIN
        )
    }
}

public class ActionTrampoline<T>: NSObject {
    private var action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    public func action(sender: Any) {
        guard let sender = sender as? T else { return }
        action(sender)
    }
}
