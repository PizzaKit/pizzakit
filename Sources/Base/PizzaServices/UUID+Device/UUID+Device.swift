import Foundation
import KeychainSwift
import Defaults
import Combine
import StableID
import PizzaCore

public protocol PizzaUUIDUserIdProvider {
    var userId: AnyPublisher<String?, Never> { get }
}

public enum PizzaUUID: StableIDDelegate {

    private static let keychain = KeychainSwift()
    private static let deviceKey = "pizza_device_uuid"
    private static let installationKey = "pizza_installation_uuid"

    /// Unique identifier for device. Stored in keychain - so will be
    /// the same for the same device after reinstalling the app
    public static var deviceUUID: String {
        getOrCreate(key: deviceKey, fromKeychain: true, fromDefaults: true)
    }

    /// Unique identifier for installation. Stored in UserDefaults - so will be
    /// different after reinstalling the app
    public static var installationUUID: String {
        getOrCreate(key: installationKey, fromKeychain: false, fromDefaults: true)
    }

    private static let _userIDSubject = CurrentValueSubject<String, Never>(StableID.id)
    /// Unique identifier for user. Stored in iCloud - so it will be the same
    /// between user's devices
    /// 
    /// User identifier for RevenueCat inApp Purchases
    /// https://www.reddit.com/r/iOSProgramming/comments/1db5ksy/revenue_cat_integration/
    public static var userIDPublisher: PizzaRPublisher<String, Never> {
        PizzaCurrentValueRPublisher(
            subject: _userIDSubject
        )
    }

    public static func configure() {
        StableID.configure()
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

    // MARK: - StableIDDelegate

    public func willChangeID(currentID: String, candidateID: String) -> String? {
        return candidateID
    }

    public func didChangeID(newID: String) {
        Self._userIDSubject.send(newID)
    }

}
