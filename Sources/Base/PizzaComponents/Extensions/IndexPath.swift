import UIKit

private protocol _UIKitCollection {
    var _indexPathsForVisibleItems: [IndexPath] { get }
    var _numberOfSections: Int { get }
    func _numberOfItems(inSection: Int) -> Int
    func _cellForItem(at indexPath: IndexPath) -> UIView?
}

extension UITableView: _UIKitCollection {

    var _indexPathsForVisibleItems: [IndexPath] {
        indexPathsForVisibleRows ?? []
    }
    var _numberOfSections: Int {
        numberOfSections
    }
    func _numberOfItems(inSection: Int) -> Int {
        numberOfRows(inSection: inSection)
    }
    func _cellForItem(at indexPath: IndexPath) -> UIView? {
        cellForRow(at: indexPath)
    }

}

extension UICollectionView: _UIKitCollection {

    var _indexPathsForVisibleItems: [IndexPath] {
        indexPathsForVisibleItems
    }
    var _numberOfSections: Int {
        numberOfSections
    }
    func _numberOfItems(inSection: Int) -> Int {
        numberOfItems(inSection: inSection)
    }
    func _cellForItem(at indexPath: IndexPath) -> UIView? {
        cellForItem(at: indexPath)
    }

}

extension IndexPath {

    private static func previousIndexPath(
        for collection: _UIKitCollection,
        at indexPath: IndexPath?
    ) -> IndexPath? {
        guard let indexPath else { return nil }
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                return nil
            } else if indexPath.section > 0 {
                var newSection = indexPath.section - 1

                // обрабатываем случай, когда в секции 0 элементов (например когда в секции только header) -
                // в таком случае пытаемся перейти к предыдущей секции
                while collection._numberOfItems(inSection: newSection) == 0 {
                    newSection -= 1

                    if newSection < 0 {
                        return nil
                    }
                }

                return .init(
                    row: collection._numberOfItems(inSection: newSection) - 1,
                    section: newSection
                )
            } else {
                return nil
            }
        } else if indexPath.row > 0 {
            return .init(
                row: indexPath.row - 1,
                section: indexPath.section
            )
        } else {
            return nil
        }
    }

    private static func nextIndexPath(
        for collection: _UIKitCollection,
        at indexPath: IndexPath?
    ) -> IndexPath? {
        guard let indexPath else { return nil }
        let numberOfItemsInCurrentSection = collection._numberOfItems(
            inSection: indexPath.section
        )
        if indexPath.row < (numberOfItemsInCurrentSection - 1) {
            return .init(
                row: indexPath.row + 1,
                section: indexPath.section
            )
        } else if indexPath.row == (numberOfItemsInCurrentSection - 1) {
            let numberOfSections = collection._numberOfSections
            if indexPath.section < (numberOfSections - 1) {

                var newSection = indexPath.section + 1
                while collection._numberOfItems(inSection: newSection) == 0 {
                    newSection += 1
                    if newSection >= numberOfSections {
                        return nil
                    }
                }

                return .init(
                    row: 0,
                    section: newSection
                )
            } else if indexPath.section == (numberOfSections - 1) {
                return nil
            }
            return nil
        }
        return nil
    }

    static func getIndexPathsForNonVisibleButExistingCells(
        for tableView: UITableView
    ) -> [IndexPath] {
        _getIndexPathsForNonVisibleButExistingCells(for: tableView)
    }
    static func getIndexPathsForNonVisibleButExistingCells(
        for collectionView: UICollectionView
    ) -> [IndexPath] {
        _getIndexPathsForNonVisibleButExistingCells(for: collectionView)
    }

    private static func _getIndexPathsForNonVisibleButExistingCells(
        for collection: _UIKitCollection
    ) -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        if
            let minSectionIndex = collection._indexPathsForVisibleItems.map({ $0.section }).min(),
            let minIndex = collection._indexPathsForVisibleItems
                .filter({ $0.section == minSectionIndex })
                .map({ $0.item })
                .min()
        {
            var currentIndexPath: IndexPath? = IndexPath(
                row: minIndex,
                section: minSectionIndex
            )
            var foundNil = false
            while let prev = previousIndexPath(for: collection, at: currentIndexPath), !foundNil {
                let cell = collection._cellForItem(at: prev)
                if cell == nil {
                    foundNil = true
                } else {
                    indexPaths.append(prev)
                }
                currentIndexPath = prev
            }
        }
        if
            let maxSectionIndex = collection._indexPathsForVisibleItems.map({ $0.section }).max(),
            let maxIndex = collection._indexPathsForVisibleItems
                .filter({ $0.section == maxSectionIndex })
                .map({ $0.item })
                .max()
        {
            var currentIndexPath: IndexPath? = IndexPath(
                row: maxIndex,
                section: maxSectionIndex
            )
            var foundNil = false
            while let next = nextIndexPath(for: collection, at: currentIndexPath), !foundNil {
                let cell = collection._cellForItem(at: next)
                if cell == nil {
                    foundNil = true
                } else {
                    indexPaths.append(next)
                }
                currentIndexPath = next
            }
        }

        return indexPaths
    }

}
