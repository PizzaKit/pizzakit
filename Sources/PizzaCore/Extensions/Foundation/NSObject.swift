import Foundation

extension NSObject {

    /**
     SparrowKit: Get class name of object.
     */
    public var className: String {
        return String(describing: type(of: self))
    }
}
