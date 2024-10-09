import Foundation
import UserNotifications
import UIKit
import PizzaCore

/// Helper for manipulating with permissions
public enum PizzaPushNotificationsPermissionHelper {

    // MARK: - Public Methods

    public static func requestAuthorization(completion: PizzaClosure<Bool>?) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in
                completion?(granted)
            }
        )
    }

    public static func getCurrentPermission(completion: PizzaClosure<Bool>?) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .authorized, .provisional:
                    completion?(true)
                case .denied, .notDetermined:
                    completion?(false)
                default:
                    break
            }
        }
    }

    public static func goToSettings() {
        let url: String = {
            if #available(iOS 16.0, *) {
                return UIApplication.openNotificationSettingsURLString
            } else {
                return UIApplication.openSettingsURLString
            }
        }()
        guard let settingsUrl = URL(string: url) else { return }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }

}
