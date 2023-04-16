import CryptoKit
import Foundation

public enum PizzaCryptoHelpers {

    public enum LifeTime {
        case oneDay(Date)
        case appVersion(String)
        case unlimited

        public static func from(
            optionNumber: Int,
            appVersion: String,
            date: Date
        ) -> LifeTime? {
            if optionNumber == 1 {
                return .oneDay(date)
            }
            if optionNumber == 2 {
                return .appVersion(appVersion)
            }
            if optionNumber == 3 {
                return .unlimited
            }

            return nil
        }

        var stringValue: String {
            switch self {
            case .appVersion(let appVersion):
                return "exact_version_\(appVersion)"
            case .oneDay(let date):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM.dd.yyyy"
                return "one_day_\(dateFormatter.string(from: date) ?? "<unknown>")"
            case .unlimited:
                return "unlimited"
            }
        }
    }

    public static func createPrivatePublicKeys() -> (
        privateKey: String,
        publicKey: String
    ) {
        let privateKey = Curve25519.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        return (
            privateKey: privateKey.rawRepresentation.hexadecimal,
            publicKey: publicKey.rawRepresentation.hexadecimal
        )
    }

    public static func createMessageDigest(string: String) -> String {
        SHA256.hash(data: Data(string.utf8)).hexadecimal
    }

    public static func createMessageDigest(
        string: String,
        sault: String,
        lifeTime: LifeTime
    ) -> String {
        createMessageDigest(
            string: "\(string)__\(sault)__\(lifeTime.stringValue)"
        )
    }

    public static func createMessageDigest(
        string: String,
        sault: String
    ) -> String {
        let finalString = string + sault
        let hash = SHA256.hash(data: Data(finalString.utf8))
        return hash.hexadecimal
    }

    public static func createSignature(
        privateKey: String,
        messageDigest: String
    ) -> String? {
        guard
            let privateKeyData = Data(hexString: privateKey),
            let messageDigestData = Data(hexString: messageDigest),
            let privateKey = try? Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData),
            let signature = try? privateKey.signature(for: messageDigestData)
        else { return nil }
        return signature.hexadecimal
    }

    public static func verifySignature(
        signature: String,
        messageDigest: String,
        publicKey: String
    ) -> Bool {
        guard
            let publicKeyData = Data(hexString: publicKey),
            let signatureData = Data(hexString: signature),
            let messageDigestData = Data(hexString: messageDigest),
            let publicKey = try? Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData),
            let isValidSign = try? publicKey.isValidSignature(
                signatureData,
                for: messageDigestData
            )
        else { return false }
        return isValidSign
    }

}
