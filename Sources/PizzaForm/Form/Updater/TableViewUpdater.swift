import UIKit

public class TableViewUpdater: NSObject, Updater, UITableViewDelegate {

    public struct SelectionContext {
        let indexPath: IndexPath
        let cellNode: CellNode
    }
    public typealias Target = UITableView

    public var didSelect: ((SelectionContext) -> Void)?
    private var dataSource: UITableViewDiffableDataSource<AnyHashable, CellNode>!

    public func initialize(target: UITableView) {
        dataSource = .init(
            tableView: target,
            cellProvider: { tableView, indexPath, cellNode in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellNode.component.reuseIdentifier, for: indexPath) as! (UITableViewCell & ComponentRenderable)

                cell.render(component: cellNode.component, renderType: .hard)

                return cell
            }
        )
        dataSource.defaultRowAnimation = .fade
        target.delegate = self
    }

    public func performUpdates(target: UITableView, data: [Section]) {
        // register if needed
        let allCellIdentifiers = data.flatMap { $0.cells }.map { $0.component.reuseIdentifier }
        allCellIdentifiers.forEach {
            target.register(FormTableViewCell.self, forCellReuseIdentifier: $0)
        }

        // update data source
        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, CellNode>()
        for section in data {
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.cells, toSection: section.id)
        }

        let allOldCellNodes = dataSource.snapshot().itemIdentifiers
        let newCellNodes = data.flatMap { $0.cells }
        let itemsToReload = (target.indexPathsForVisibleRows ?? [])
            .compactMap { dataSource.itemIdentifier(for: $0) }
            .filter { allOldCellNodes.contains($0) }
            .compactMap { item in newCellNodes.first(where: { $0 == item }) }

        dataSource.apply(
            snapshot,
            animatingDifferences: dataSource.numberOfSections(in: target) != 0 && target.window != nil
        )
        renderVisibleComponents(in: target)
    }

    public func renderVisibleComponents(in target: UITableView) {
        let itemsToRender: [(cell: ComponentRenderable, cellNode: CellNode, indexPath: IndexPath)] = (target.indexPathsForVisibleRows ?? [])
            .compactMap { indexPath in
                if
                    let cellNode = dataSource.itemIdentifier(for: indexPath),
                    let cell = target.cellForRow(at: indexPath) as? ComponentRenderable
                {
                    return (cell: cell, cellNode: cellNode, indexPath: indexPath)
                }
                return nil
            }
        if !itemsToRender.isEmpty {
            itemsToRender.forEach {
                $0.cell.render(component: $0.cellNode.component, renderType: .soft)
            }
        }
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard
            let cellNode = dataSource.itemIdentifier(for: indexPath)
        else { return false }
        return cellNode.component.shouldHighlight()
    }

}
