import UIKit

public extension UIApplication {

    /// Version of application
    static var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    /// Build number of application
    static var buildNumber: String? {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    /// Name for app
    var displayName: String? {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    /// Bundle identifier of app
    var bundleIdentifier: String? {
        Bundle.main.bundleIdentifier
    }

    /// Key window
    static var keyWindow: UIWindow? {
        return allWindows
            .first(where: { $0.isKeyWindow })
    }

    static var allWindows: [UIWindow] {
        return shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows ?? []
    }
}
