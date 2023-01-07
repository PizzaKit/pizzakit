import Foundation

extension Data {
    func decoded<T>() -> T? where T: Decodable {
        return try? PropertyListDecoder().decode(T.self, from: self)
    }
}
