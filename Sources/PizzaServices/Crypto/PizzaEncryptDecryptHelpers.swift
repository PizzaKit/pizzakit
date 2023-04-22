import CryptoKit
import Foundation
import PizzaCore

public enum PizzaEncryptDecryptHelpers {

    public static func createSymmetricKey() -> String {
        SymmetricKey(size: .bits192).extract()
    }

    public static func encrypt(
        message: String,
        key: String
    ) -> String? {
        guard
            let key = SymmetricKey(hexString: key),
            let stringData = message.data(using: .utf8),
            let seal = try? AES.GCM.seal(stringData, using: key),
            let sealString = seal.combined?.hexadecimal
        else { return nil }
        return sealString
    }

    public static func decrypt(
        seal: String,
        key: String
    ) -> String? {
        guard
            let key = SymmetricKey(hexString: key),
            let sealData = Data(hexString: seal),
            let seal = try? AES.GCM.SealedBox(combined: sealData),
            let decryptedData = try? AES.GCM.open(seal, using: key),
            let decryptedString = String(data: decryptedData, encoding: .utf8)
        else { return nil }
        return decryptedString
    }
    
}

extension SymmetricKey {
    init?(hexString: String) {
        guard let data = Data(hexString: hexString) else {
            return nil
        }
        self.init(data: data)
    }
    func extract() -> String {
        withUnsafeBytes { pointer in
            pointer.hexadecimal
        }
    }
}
