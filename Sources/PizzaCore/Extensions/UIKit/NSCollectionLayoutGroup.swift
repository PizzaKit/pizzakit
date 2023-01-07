import UIKit

public extension NSCollectionLayoutGroup {

    static func pizzaHorizontal(
        layoutSize: NSCollectionLayoutSize,
        repeatingSubitem subitem: NSCollectionLayoutItem,
        count: Int
    ) -> NSCollectionLayoutGroup {
        if #available(iOS 16.0, *) {
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                repeatingSubitem: subitem,
                count: count
            )
        } else {
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitem: subitem,
                count: count
            )
        }
    }

}
