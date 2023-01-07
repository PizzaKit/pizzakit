import Foundation
import UIKit

public protocol Do {}

extension Do where Self: Any {

    /// Method for easily applying multiple methods to entity
    ///
    /// ```
    /// titleLabel.do {
    ///     $0.font = .systemFont(size: 14)
    ///     $0.color = .label
    /// }
    /// ```
    @discardableResult @inlinable
    public func `do`(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

}

extension NSObject: Do {}

extension CGPoint: Do {}
extension CGRect: Do {}
extension CGSize: Do {}
extension CGVector: Do {}

extension Array: Do {}
extension Dictionary: Do {}
extension Set: Do {}

extension UIEdgeInsets: Do {}
extension UIOffset: Do {}
extension UIRectEdge: Do {}
