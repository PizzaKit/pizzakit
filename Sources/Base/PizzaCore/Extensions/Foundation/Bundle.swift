import Foundation

public extension Bundle {
    var isExtension: Bool {
        bundlePath.hasSuffix(".appex")
    }
}
