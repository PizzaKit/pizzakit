import Foundation

extension NSLock {
    public func withLock<ReturnValue>(
        _ body: () throws -> ReturnValue
    ) rethrows -> ReturnValue {
        self.lock()
        defer {
            self.unlock()
        }
        return try body()
    }
}
