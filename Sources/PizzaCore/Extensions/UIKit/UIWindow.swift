import UIKit
import Foundation
import NotificationCenter

public extension UIWindow {

    open override func motionEnded(
        _ motion: UIEvent.EventSubtype,
        with event: UIEvent?
    ) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .shakeGesture, object: nil)
        }
        super.motionEnded(motion, with: event)
    }

}

public extension Notification.Name {
    static let shakeGesture = Notification.Name("windowShakeGesture")
}
