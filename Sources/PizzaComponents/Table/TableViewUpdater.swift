import UIKit
import PizzaCore

private class CustomDataSource: UITableViewDiffableDataSource<ComponentSection, ComponentNode> {

    var onCanMoveRow: ((IndexPath) -> Bool)?
    var onMoveRow: ((IndexPath, IndexPath) -> Void)?

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return onCanMoveRow?(indexPath) ?? false
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
         onMoveRow?(sourceIndexPath, destinationIndexPath)
    }

}

public enum TableCellSpawnPolicy {
    case initialize
    case reuse
}

private protocol TableCellSpawner {
    func spawn(
        for tableView: UITableView,
        at indexPath: IndexPath,
        componentNode: ComponentNode
    ) -> UITableViewCell
}

private class TableInitializeCellSpawner: TableCellSpawner {

    private var cache: [AnyHashable: UITableViewCell] = [:]

    func spawn(
        for tableView: UITableView,
        at indexPath: IndexPath,
        componentNode: ComponentNode
    ) -> UITableViewCell {
        if let cached = cache[componentNode.id] {
            return cached
        }
        let new = ComponentTableViewCell()
        cache[componentNode.id] = new
        return new
    }

}

private class TableReuseCellSpawner: TableCellSpawner {
    func spawn(
        for tableView: UITableView,
        at indexPath: IndexPath,
        componentNode: ComponentNode
    ) -> UITableViewCell {
        tableView.dequeueReusableCell(
            withIdentifier: componentNode.component.reuseIdentifier,
            for: indexPath
        )
    }
}

open class TableViewUpdater: NSObject, Updater, UITableViewDelegate {

    public typealias Target = UITableView
    public private(set) var dataSource: UITableViewDiffableDataSource<ComponentSection, ComponentNode>!
    private var tableCellSpawner: TableCellSpawner = TableReuseCellSpawner()
    public var updaterDelegate: UpdaterDelegate?

    public var onScrollViewDidScroll: PizzaClosure<UITableView>?

    open func initialize(tableSpawnPolicy: TableCellSpawnPolicy) {
        switch tableSpawnPolicy {
        case .initialize:
            tableCellSpawner = TableInitializeCellSpawner()
        case .reuse:
            tableCellSpawner = TableReuseCellSpawner()
        }
    }

    open func initialize(target: UITableView) {
        let customDataSource = CustomDataSource(
            tableView: target,
            cellProvider: { [unowned self] tableView, indexPath, componentNode in
                let cell = self.tableCellSpawner.spawn(
                    for: tableView,
                    at: indexPath,
                    componentNode: componentNode
                ) as! (UITableViewCell & ComponentRenderable)

                cell.render(
                    component: componentNode.component,
                    renderType: .hard
                )

                return cell
            }
        )
        customDataSource.onCanMoveRow = { [weak self] indexPath in
            guard let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else { return false }
            return self?.updaterDelegate?.canMoveComponent(in: section) ?? false
        }
        customDataSource.onMoveRow = { [weak self] source, target in
            guard 
                let fromSection = self?.dataSource.sectionIdentifier(for: source.section),
                let toSection = self?.dataSource.sectionIdentifier(for: target.section)
            else { return }
            self?.updaterDelegate?.moveComponent(
                from: .init(section: fromSection, index: source.row),
                to: .init(section: toSection, index: target.row)
            )
        }
        dataSource = customDataSource
        dataSource.defaultRowAnimation = .fade
        target.delegate = self
    }

    open func getCell(
        tableView: UITableView,
        componentId: AnyHashable
    ) -> UIView? {
        getCell(target: tableView, componentId: componentId)
    }

    open func getCell(
        target: UITableView,
        componentId: AnyHashable
    ) -> UIView? {
        guard let indexPath = dataSource.indexPath(for: .init(component: FakeComponent(id: componentId))) else {
            return nil
        }
        return target.cellForRow(at: indexPath)
    }

    open func performUpdates(target: UITableView, sections: [ComponentSection]) {
        // -----------------
        // | registrations |
        // -----------------

        // cells
        let allCellIdentifiers = sections.flatMap { $0.cellsNode }.map { $0.component.reuseIdentifier }
        allCellIdentifiers.forEach {
            target.register(ComponentTableViewCell.self, forCellReuseIdentifier: $0)
        }

        // headers
        let allHeaderIdentifiers = sections.compactMap { $0.headerNode?.component.reuseIdentifier }
        allHeaderIdentifiers.forEach {
            target.register(ComponentTableReusableView.self, forHeaderFooterViewReuseIdentifier: $0)
        }

        // footers
        let allFooterIdentifiers = sections.compactMap { $0.footerNode?.component.reuseIdentifier }
        allFooterIdentifiers.forEach {
            target.register(ComponentTableReusableView.self, forHeaderFooterViewReuseIdentifier: $0)
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
            animatingDifferences: {
                return dataSource.numberOfSections(in: target) != 0 && target.window != nil
            }()
        )


//        guard target.window != nil else { return }

        // update visible components
        DispatchQueue.main.async {
            self.renderVisibleComponents(in: target)
        }


        // need to update size of header/footer
        if !target.isEditing {
            target.beginUpdates()
            target.endUpdates()
        }

        // PS. Хаки с isEditing нужны, чтобы красиво работал reorder. В обмен на это ячейки с изменяемой
        // высотой работать будут плохо при isEditing или вообще не будут ))
    }

    open func renderVisibleComponents(in target: UITableView) {
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

        // в iOS 15 когда ячейка только уходит с экрана, она все еще существует.
        // Поэтому она при появлении на экран не будет зарендерена через cellForItem, но и
        // в indexPathsForVisibleRows тоже не попадает.
        // Поэтому мы от первого и последнего элемента расходимся в стороны и ищем ненулевые ячейки, а затем
        // рендерим эти ячейки
        let indexPathForHardRender = IndexPath.getIndexPathsForNonVisibleButExistingCells(for: target)
        let itemsToHardRender: [(cell: ComponentRenderable, componentNode: ComponentNode, indexPath: IndexPath)] = indexPathForHardRender
            .compactMap { indexPath in
                if
                    let componentNode = dataSource.itemIdentifier(for: indexPath),
                    let cell = target.cellForRow(at: indexPath) as? ComponentRenderable
                {
                    return (cell: cell, componentNode: componentNode, indexPath: indexPath)
                }
                return nil
            }
        itemsToHardRender.forEach {
            $0.cell.render(component: $0.componentNode.component, renderType: .hard)
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

    open func tableView(
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

    open func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let selectableComponent = componentNode.component as? (any SelectableComponent),
            selectableComponent.onSelect != nil
        else { return false }
        return true
    }

    open func tableView(
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
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerComponent.reuseIdentifier) as! ComponentTableReusableView
            view.render(component: headerComponent, renderType: .hard)
            return view
        } else {
            return nil
        }
    }

    open func tableView(
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
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerComponent.reuseIdentifier) as! ComponentTableReusableView
            view.render(component: footerComponent, renderType: .hard)
            return view
        } else {
            return nil
        }
    }

    open func tableView(
        _ tableView: UITableView,
        accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let componentWithAccessories = componentNode.component as? ComponentWithAccessories
        else { return }
        for accessory in componentWithAccessories.accessories {
            if case .info(let onPress) = accessory {
                onPress?()
            }
        }
    }

    open func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let componentWithSwipeActions = componentNode.component as? ComponentWithSwipeActions,
            !componentWithSwipeActions.trailingSwipeActions.isEmpty
        else { return nil }
        return .init(
            actions: componentWithSwipeActions.trailingSwipeActions.map { item in
                .init(
                    style: item.isDestructive ? .destructive : .normal,
                    title: item.title,
                    handler: { _, _, completion in
                        item.action(completion)
                    }
                )
            }
        )
    }

    open func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let componentWithSwipeActions = componentNode.component as? ComponentWithSwipeActions,
            !componentWithSwipeActions.leadingSwipeActions.isEmpty
        else { return nil }
        return .init(
            actions: componentWithSwipeActions.leadingSwipeActions.map { item in
                .init(
                    style: item.isDestructive ? .destructive : .normal,
                    title: item.title,
                    handler: { _, _, completion in
                        item.action(completion)
                    }
                )
            }
        )
    }

    open func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let view = cell as? ComponentRenderable,
            let renderTarget = view.renderTarget
        else { return }
        AnyComponent(componentNode.component)
            .renderTargetWillDisplay(renderTarget)
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView as! Target)
    }

    open func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        guard
            let componentNode = dataSource.sectionIdentifier(for: section)?.headerNode,
            let view = view as? ComponentRenderable,
            let renderTarget = view.renderTarget
        else { return }
        AnyComponent(componentNode.component)
            .renderTargetWillDisplay(renderTarget)
    }

    open func tableView(
        _ tableView: UITableView,
        willDisplayFooterView view: UIView,
        forSection section: Int
    ) {
        guard
            let componentNode = dataSource.sectionIdentifier(for: section)?.footerNode,
            let view = view as? ComponentRenderable,
            let renderTarget = view.renderTarget
        else { return }
        AnyComponent(componentNode.component)
            .renderTargetWillDisplay(renderTarget)
    }

    open func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        if dataSource.sectionIdentifier(for: section)?.headerNode != nil {
            return UITableView.automaticDimension
        }
        if tableView.style == .insetGrouped {
            return 30
        }
        return 0
    }

    open func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        if dataSource.sectionIdentifier(for: section)?.footerNode != nil {
            return UITableView.automaticDimension
        }
        return 0
    }

}

public struct FakeComponent: IdentifiableComponent {

    public var id: AnyHashable

    public init(id: AnyHashable) {
        self.id = id
    }

    public func createRenderTarget() -> UIView {
        UIView()
    }

    public func render(in renderTarget: UIView, renderType: RenderType) {
    }

}
