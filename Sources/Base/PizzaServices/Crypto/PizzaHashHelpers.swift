import PizzaCore
import CryptoKit
import Foundation

public enum PizzaHashHelpers {

    public static func sha256(string: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        return SHA256.hash(data: data).hexadecimal
    }

    public static func md5(string: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        return Insecure.MD5.hash(data: data).hexadecimal
    }

}
