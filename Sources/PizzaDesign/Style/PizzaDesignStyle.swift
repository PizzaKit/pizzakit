import UIKit

public protocol UIStyleProtocol {
    associatedtype Control: UIView
    func apply(for: Control)
}

open class UIStyle<Control: UIView>: UIStyleProtocol {
    public init() {}
    open func apply(for: Control) {}
}
