import UIKit

public extension CALayer {

    var presentationOrSelf: Self {
        presentation() ?? self
    }

    func addShakeAnimation() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true

        add(animation, forKey: "shake")
    }

}
