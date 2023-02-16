////import UIKit
////import PizzaKit
////import DifferenceKit
//
////open class PizzaFormAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
////
////    // MARK: - Private Properties
////
////    private var data: [ArraySection<AnyDifferentiable, AnyDifferentiable>] = []
////    private let collectionView: UICollectionView
////
////    // MARK: - Initialization
////
////    init(collectionView: UICollectionView) {
////        self.collectionView = collectionView
////        super.init()
////
////        collectionView.register(UICollectionViewListCell.self)
////
////        collectionView.collectionViewLayout = createLayout()
////        collectionView.dataSource = self
////        collectionView.delegate = self
////    }
////
////    // MARK: - Methods
////
////    func configure(sections: [any PizzaFormSection]) {
////        let newData = sections.map {
////            ArraySection<AnyDifferentiable, AnyDifferentiable>(
////                model: AnyDifferentiable($0),
////                elements: $0.items.map { AnyDifferentiable($0) }
////            )
////        }
////        let changeset = StagedChangeset(source: data, target: newData)
////
////        collectionView.reload(using: changeset, setData: { data in
////            self.data = data
////        })
////    }
////
////    // MARK: - UICollectionViewDataSource
////
////    public func collectionView(
////        _ collectionView: UICollectionView,
////        cellForItemAt indexPath: IndexPath
////    ) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(
////            withClass: UICollectionViewListCell.self,
////            for: indexPath
////        )
////
////        let item = getItem(indexPath: indexPath)
////
////        var contentConfiguration = cell.defaultContentConfiguration()
////        contentConfiguration.text = item.differenceIdentifier as? String
////        cell.contentConfiguration = contentConfiguration
////
////        return cell
////    }
////
////    public func collectionView(
////        _ collectionView: UICollectionView,
////        numberOfItemsInSection section: Int
////    ) -> Int {
////        return data[section].elements.count
////    }
////
////    // MARK: - UICollectionViewDelegate
////
////    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        guard
////            let item = getItem(indexPath: indexPath).base as? PizzaFormSelectableItem
////        else {
////            collectionView.deselectItem(at: indexPath, animated: false)
////            return
////        }
////        item.onSelect()
////        if item.shouldDeselectImmediately {
////            collectionView.deselectItem(at: indexPath, animated: true)
////        }
////    }
////
////    // MARK: - Private Methods
////
////    private func getItem(indexPath: IndexPath) -> AnyDifferentiable {
////        data[indexPath.section].elements[indexPath.item]
////    }
////
////    private func createLayout() -> UICollectionViewLayout {
////        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
////            let configuration = UICollectionLayoutListConfiguration(
////                appearance: .insetGrouped
////            )
////            let section = NSCollectionLayoutSection.list(
////                using: configuration,
////                layoutEnvironment: environment
////            )
////
////            return section
////        }
////
////        return layout
////    }
////
////}
//
//open class PizzaFormAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
//
//    // MARK: - Private Properties
//
//    private var data: [ArraySection<AnyDifferentiable, AnyDifferentiable>] = []
//    private let tableView: UITableView
//
//    // MARK: - Initialization
//
//    init(tableView: UITableView) {
//        self.tableView = tableView
//        super.init()
//
//        tableView.register(UITableViewCell.self)
//
////        collectionView.collectionViewLayout = createLayout()
//        tableView.dataSource = self
//        tableView.delegate = self
//    }
//
//    // MARK: - Methods
//
//    func configure(sections: [any PizzaFormSection]) {
//        let newData = sections.map {
//            ArraySection<AnyDifferentiable, AnyDifferentiable>(
//                model: AnyDifferentiable($0),
//                elements: $0.items.map { AnyDifferentiable($0) }
//            )
//        }
//        let changeset = StagedChangeset(source: data, target: newData)
//
//        tableView.reload(using: changeset, with: .fade, setData: { data in
//            self.data = data
//        })
//    }
//
//    // MARK: - UICollectionViewDataSource
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withClass: UITableViewCell.self,
//            for: indexPath
//        )
//
//        let item = getItem(indexPath: indexPath)
//        cell.textLabel?.text = item.differenceIdentifier as? String
//
//        return cell
//    }
//
////    public func collectionView(
////        _ collectionView: UICollectionView,
////        cellForItemAt indexPath: IndexPath
////    ) -> UICollectionViewCell {
//
////
////        let item = getItem(indexPath: indexPath)
////
////        var contentConfiguration = cell.defaultContentConfiguration()
////        contentConfiguration.text = item.differenceIdentifier as? String
////        cell.contentConfiguration = contentConfiguration
////
////        return cell
////    }
////
////    public func collectionView(
////        _ collectionView: UICollectionView,
////        numberOfItemsInSection section: Int
////    ) -> Int {
////        return data[section].elements.count
////    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].elements.count
//    }
//
//    // MARK: - UICollectionViewDelegate
//
////    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
////    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard
//            let item = getItem(indexPath: indexPath).base as? PizzaFormSelectableItem
//        else {
//            tableView.deselectRow(at: indexPath, animated: false)
//            return
//        }
//        item.onSelect()
//        if item.shouldDeselectImmediately {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//    }
//
//    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        false
//    }
//
//    // MARK: - Private Methods
//
//    private func getItem(indexPath: IndexPath) -> AnyDifferentiable {
//        data[indexPath.section].elements[indexPath.item]
//    }
//
////    private func createLayout() -> UICollectionViewLayout {
////        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
////            let configuration = UICollectionLayoutListConfiguration(
////                appearance: .insetGrouped
////            )
////            let section = NSCollectionLayoutSection.list(
////                using: configuration,
////                layoutEnvironment: environment
////            )
////
////            return section
////        }
////
////        return layout
////    }
//
//}
