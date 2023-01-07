import UIKit

public extension UICollectionView {

    // MARK: - Initialization

    static func withLayout<Layout: UICollectionViewLayout>(
        _ layout: Layout,
        layoutConfigurationBlock: PizzaClosure<Layout>
    ) -> UICollectionView {
        return .init(
            frame: .zero,
            collectionViewLayout: layout.do {
                layoutConfigurationBlock($0)
            }
        )
    }

    static func withFlowLayout(
        layoutConfigurationBlock: PizzaClosure<UICollectionViewFlowLayout>
    ) -> UICollectionView {
        withLayout(
            UICollectionViewFlowLayout(), 
            layoutConfigurationBlock: layoutConfigurationBlock
        )
    }

    // MARK: - Registration

    /// Method for easy registering cell
    func register<T: UICollectionViewCell>(_ class: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: `class`))
    }

    /// Method for easy dequeuing cell
    func dequeueReusableCell<T: UICollectionViewCell>(
        withClass class: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: String(describing: `class`),
            for: indexPath
        ) as? T else {
            fatalError("unable to dequeue collection cell with class: \(`class`)")
        }
        return cell
    }

    /// Method for easy registering reusable view
    func register<T: UICollectionReusableView>(
        _ class: T.Type,
        kind: String
    ) {
        register(
            T.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: String(describing: `class`)
        )
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        withClass class: T.Type,
        kind: String,
        for indexPath: IndexPath
    ) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: `class`),
            for: indexPath
        ) as? T else {
            fatalError("unable to dequeue collection reusable view with class: \(`class`)")
        }
        return view
    }

    // MARK: - Layout

    /// Method for invalidating layout with or without animation
    func invalidateLayout(animated: Bool) {
        if animated {
            performBatchUpdates({
                self.collectionViewLayout.invalidateLayout()
            }, completion: nil)
        } else {
            collectionViewLayout.invalidateLayout()
        }
    }

}
