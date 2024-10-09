import Foundation

public extension Sequence where Self.Element == UInt8 {
    /// Hexadecimal string representation of `Data` object.
    var hexadecimal: String {
        map { String(format: "%02x", $0) }.joined()
    }
}
