import UIKit

public protocol UIStyleProtocol {
    associatedtype Control: UIResponder
    func apply(for: Control)
}

open class UIStyle<Control: UIResponder>: UIStyleProtocol {
    public init() {}
    open func apply(for: Control) {}
}
