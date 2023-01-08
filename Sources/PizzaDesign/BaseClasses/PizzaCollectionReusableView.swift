import UIKit

open class PizzaCollectionReusableView: UICollectionReusableView {

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Public Methods

    /// Method for initial configuration
    open func commonInit() {
    }

}
