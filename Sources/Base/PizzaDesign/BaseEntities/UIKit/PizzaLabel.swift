import UIKit

open class PizzaLabel: UILabel {

    open var style: UIStyle<PizzaLabel>? {
        didSet {
            style?.apply(for: self)
        }
    }

    open override var text: String? {
        didSet {
            style?.apply(for: self)
        }
    }

}
