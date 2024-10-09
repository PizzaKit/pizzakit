import Foundation

public extension JSONDecoder {
    func set(context: Any?, forKey key: String) {
        let infoKey = CodingUserInfoKey(rawValue: key)!
        userInfo[infoKey] = context
    }
}
