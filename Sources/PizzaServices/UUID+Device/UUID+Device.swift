import Foundation
import KeychainSwift
import Defaults

public enum PizzaUUID {

    private static let keychain = KeychainSwift()
    private static let deviceKey = "pizza_device_uuid"

    public static var deviceUUID: String {
        getOrCreate(key: deviceKey, fromKeychain: true, fromDefaults: true)
    }

    private static func getOrCreate(key: String, fromKeychain: Bool, fromDefaults: Bool) -> String {
        if let currentValue = get(key: key, fromKeychain: fromKeychain, fromDefaults: fromDefaults) {

            /// вдруг у нас взялось значение из keychain, но мы положим в UD, чтобы был доступ быстрее
            set(key: key, value: currentValue, toKeychain: true, toDefaults: true)

            return currentValue
        }

        let newValue = UUID().uuidString
            .replacingOccurrences(of: "-", with: "")
            .lowercased()

        set(key: key, value: newValue, toKeychain: true, toDefaults: true)

        return newValue
    }

    private static func get(key: String, fromKeychain: Bool, fromDefaults: Bool) -> String? {
        var value: String?

        if value == nil && fromKeychain {
            value = keychain.get(key)
        }

        if value == nil && fromDefaults {
            let key = Defaults.Key<String?>(key, default: nil)
            value = Defaults[key]
        }

        return value
    }

    private static func set(key: String, value: String, toKeychain: Bool, toDefaults: Bool) {
        if toDefaults {
            let key = Defaults.Key<String?>(key, default: nil)
            Defaults[key] = value
        }

        if toKeychain {
            keychain.set(value, forKey: key)
        }
    }

}
