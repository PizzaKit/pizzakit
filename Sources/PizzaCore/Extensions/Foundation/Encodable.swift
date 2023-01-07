import Foundation

extension Encodable {
    func getData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
