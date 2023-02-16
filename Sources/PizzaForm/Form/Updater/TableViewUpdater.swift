import UIKit

public class TableViewUpdater: NSObject, Updater, UITableViewDelegate {

    public struct SelectionContext {
        let indexPath: IndexPath
        let cellNode: CellNode
    }
    public typealias Target = UITableView

    public var didSelect: ((SelectionContext) -> Void)?
    private var dataSource: UITableViewDiffableDataSource<Section, CellNode>!

    public func initialize(target: UITableView) {
        dataSource = .init(
            tableView: target,
            cellProvider: { tableView, indexPath, cellNode in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: cellNode.component.reuseIdentifier,
                    for: indexPath
                ) as! (UITableViewCell & ComponentRenderable)

                cell.render(
                    component: cellNode.component,
                    renderType: .hard
                )

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

        let allHeaderIdentifiers = data.compactMap { $0.header?.component.reuseIdentifier }
        allHeaderIdentifiers.forEach {
            target.register(FormTableReusableView.self, forHeaderFooterViewReuseIdentifier: $0)
        }

        // update data source
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellNode>()
        for section in data {
            snapshot.appendSections([section])
            snapshot.appendItems(section.cells, toSection: section)
        }

        dataSource.apply(
            snapshot,
            animatingDifferences: dataSource.numberOfSections(in: target) != 0 && target.window != nil
        )
        renderVisibleComponents(in: target)
    }

    public func renderVisibleComponents(in target: UITableView) {
        if #available(iOS 15.0, *) {
            // cells
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
            itemsToRender.forEach {
                $0.cell.render(component: $0.cellNode.component, renderType: .soft)
            }

            // headers
            let sectionIndexes = Array(Set(itemsToRender.map { $0.indexPath.section }))
            let headersToRender: [(header: ComponentRenderable, viewNode: ViewNode, section: Int)] = sectionIndexes.compactMap { index in
                guard
                    let view = target.headerView(forSection: index) as? ComponentRenderable,
                    let viewNode = dataSource.sectionIdentifier(for: index)?.header
                else {
                    return nil
                }
                return (header: view, viewNode: viewNode, section: index)
            }
            headersToRender.forEach {
                $0.header.render(component: $0.viewNode.component, renderType: .soft)
            }
        }

    }

    public func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        guard
            let cellNode = dataSource.itemIdentifier(for: indexPath)
        else { return false }
        return cellNode.component.shouldHighlight()
    }

    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        if #available(iOS 15.0, *) {
            guard
                let section = dataSource.sectionIdentifier(for: section),
                let headerComponent = section.header?.component
            else {
                return nil
            }
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerComponent.reuseIdentifier) as! FormTableReusableView
            view.render(component: headerComponent, renderType: .hard)
            return view
        } else {
            return nil
        }
    }

}
