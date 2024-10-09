import Foundation

public extension Encodable {
    func getData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    func getString() -> String? {
        guard let data = getData() else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
