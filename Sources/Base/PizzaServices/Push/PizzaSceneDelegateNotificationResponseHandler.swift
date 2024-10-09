import UserNotifications
import PizzaCore

public protocol PizzaSceneDelegateNotificationResponseHandler {
    func handle(notificationResponse: UNNotificationResponse?)
}
