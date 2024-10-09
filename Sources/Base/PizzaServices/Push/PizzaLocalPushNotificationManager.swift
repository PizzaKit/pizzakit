import UserNotifications
import UIKit

open class PizzaLocalPushNotificationManager: NSObject, UNUserNotificationCenterDelegate {

    // MARK: - Initialization

    public override init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - UNUserNotificationCenterDelegate

    open func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo

        // Change this to your preferred presentation option
        completionHandler([.alert, .sound, .badge])
    }

    open func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        PizzaLogger.log(
            label: "pizza_push",
            level: .info,
            message: "Push notification received",
            payload: (userInfo as? [String: Any]) ?? [:]
        )

        if
            let targetScene = response.targetScene as? UIWindowScene,
            let sceneDelegate = targetScene.delegate as? PizzaSceneDelegateNotificationResponseHandler
        {
            sceneDelegate.handle(notificationResponse: response)
        }

        // clear badge number
        UIApplication.shared.applicationIconBadgeNumber = 0

        completionHandler()
    }

}
