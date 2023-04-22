import Foundation

public protocol PizzaPushNotificationManager {
    func didRegisterRemoteNotifications(with tokenData: Data)
    func didReceiveBackgroundNotification(userInfo: [AnyHashable: Any])
}
