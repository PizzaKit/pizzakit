import UIKit

enum FontRoundStorage {
    static var needRounded = false
}

public extension UIFont {

    var roundedIfNeeded: UIFont {
        if FontRoundStorage.needRounded {
            return self.rounded
        }
        return self
    }

}
