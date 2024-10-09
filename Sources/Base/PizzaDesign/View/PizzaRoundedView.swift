import UIKit

open class PizzaRoundedView: PizzaView {

    open override func commonInit() {
        super.commonInit()

        layer.masksToBounds = true
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.width / 2
    }

}
