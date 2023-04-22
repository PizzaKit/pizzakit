import UIKit

public class TableViewUpdater: NSObject, Updater, UITableViewDelegate {

    public struct SelectionContext {
        let indexPath: IndexPath
        let componentNode: ComponentNode
    }
    public typealias Target = UITableView

    public var didSelect: ((SelectionContext) -> Void)?
    private var dataSource: UITableViewDiffableDataSource<ComponentSection, ComponentNode>!

    public func initialize(target: UITableView) {
        dataSource = .init(
            tableView: target,
            cellProvider: { tableView, indexPath, componentNode in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: componentNode.component.reuseIdentifier,
                    for: indexPath
                ) as! (UITableViewCell & ComponentRenderable)

                cell.render(
                    component: componentNode.component,
                    renderType: .hard
                )

                return cell
            }
        )
        dataSource.defaultRowAnimation = .fade
        target.delegate = self
    }

    public func performUpdates(target: UITableView, sections: [ComponentSection]) {
        // -----------------
        // | registrations |
        // -----------------

        // cells
        let allCellIdentifiers = sections.flatMap { $0.cellsNode }.map { $0.component.reuseIdentifier }
        allCellIdentifiers.forEach {
            target.register(FormTableViewCell.self, forCellReuseIdentifier: $0)
        }

        // headers
        let allHeaderIdentifiers = sections.compactMap { $0.headerNode?.component.reuseIdentifier }
        allHeaderIdentifiers.forEach {
            target.register(FormTableReusableView.self, forHeaderFooterViewReuseIdentifier: $0)
        }

        // footers
        let allFooterIdentifiers = sections.compactMap { $0.footerNode?.component.reuseIdentifier }
        allFooterIdentifiers.forEach {
            target.register(FormTableReusableView.self, forHeaderFooterViewReuseIdentifier: $0)
        }

        // ------------

        // update data source
        var snapshot = NSDiffableDataSourceSnapshot<ComponentSection, ComponentNode>()
        for section in sections {
            snapshot.appendSections([section])
            snapshot.appendItems(section.cellsNode, toSection: section)
        }
        dataSource.apply(
            snapshot,
            animatingDifferences: dataSource.numberOfSections(in: target) != 0 && target.window != nil
        )

        guard target.window != nil else { return }

        // update visible components
        renderVisibleComponents(in: target)

        // need to update size of header/footer
        target.beginUpdates()
        target.endUpdates()
    }

    public func renderVisibleComponents(in target: UITableView) {
        if #available(iOS 15.0, *) {
            // cells
            let itemsToRender: [(cell: ComponentRenderable, componentNode: ComponentNode, indexPath: IndexPath)] = (target.indexPathsForVisibleRows ?? [])
                .compactMap { indexPath in
                    if
                        let componentNode = dataSource.itemIdentifier(for: indexPath),
                        let cell = target.cellForRow(at: indexPath) as? ComponentRenderable
                    {
                        return (cell: cell, componentNode: componentNode, indexPath: indexPath)
                    }
                    return nil
                }
            itemsToRender.forEach {
                $0.cell.render(component: $0.componentNode.component, renderType: .soft)
            }

            // headers
            let sectionIndexes = Array(Set(itemsToRender.map { $0.indexPath.section }))
            let headersToRender: [(header: ComponentRenderable, viewNode: ComponentNode, section: Int)] = sectionIndexes.compactMap { index in
                guard
                    let view = target.headerView(forSection: index) as? ComponentRenderable,
                    let viewNode = dataSource.sectionIdentifier(for: index)?.headerNode
                else {
                    return nil
                }
                return (header: view, viewNode: viewNode, section: index)
            }
            headersToRender.forEach {
                $0.header.render(component: $0.viewNode.component, renderType: .soft)
            }

            // footers
            let footersToRender: [(footer: ComponentRenderable, viewNode: ComponentNode, section: Int)] = sectionIndexes.compactMap { index in
                guard
                    let view = target.footerView(forSection: index) as? ComponentRenderable,
                    let viewNode = dataSource.sectionIdentifier(for: index)?.footerNode
                else {
                    return nil
                }
                return (footer: view, viewNode: viewNode, section: index)
            }
            footersToRender.forEach {
                $0.footer.render(component: $0.viewNode.component, renderType: .soft)
            }
        }

    }

    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let selectableComponent = componentNode.component as? (any SelectableComponent)
        else { return }
        selectableComponent.onSelect?()
        if selectableComponent.shouldDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let selectableComponent = componentNode.component as? (any SelectableComponent),
            selectableComponent.onSelect != nil
        else { return false }
        return true
    }

    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        if #available(iOS 15.0, *) {
            guard
                let section = dataSource.sectionIdentifier(for: section),
                let headerComponent = section.headerNode?.component
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

    public func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        if #available(iOS 15.0, *) {
            guard
                let section = dataSource.sectionIdentifier(for: section),
                let footerComponent = section.footerNode?.component
            else {
                return nil
            }
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerComponent.reuseIdentifier) as! FormTableReusableView
            view.render(component: footerComponent, renderType: .hard)
            return view
        } else {
            return nil
        }
    }

}
