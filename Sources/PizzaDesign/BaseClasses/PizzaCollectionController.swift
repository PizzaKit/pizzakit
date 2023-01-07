import UIKit

open class PizzaCollectionController: UICollectionViewController {

    public init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    private override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        fatalError("init(coder:) has not been implemented")
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
