import UIKit
import PizzaCore
import Combine

private class CustomDataSource: UICollectionViewDiffableDataSource<ComponentSection, ComponentNode> {

}

public class CollectionViewUpdater: NSObject, Updater, UICollectionViewDelegate {

    public typealias Target = UICollectionView
    private(set) public var dataSource: UICollectionViewDiffableDataSource<ComponentSection, ComponentNode>!

    // MARK: - Updater

    public var updaterDelegate: UpdaterDelegate?
    public var onScrollViewDidScroll: PizzaClosure<Target>?
    private var onModifyCell: PizzaClosure<UICollectionViewCell>?

    private var onWindowAppearCancellable: AnyCancellable?

    public func modifyCell(block: @escaping PizzaClosure<UICollectionViewCell>) {
        self.onModifyCell = block
    }

    public func initialize(target: Target) {
        let customDataSource = CustomDataSource(
            collectionView: target
        ) { [weak self] collectionView, indexPath, componentNode in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: componentNode.component.reuseIdentifier,
                for: indexPath
            ) as! (UICollectionViewCell & ComponentRenderable)
            self?.onModifyCell?(cell)

            cell.render(
                component: componentNode.component,
                renderType: .hard
            )

            return cell
        }
        customDataSource.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard 
                let self,
                let section = self.dataSource.sectionIdentifier(for: indexPath.section)
            else { return nil }

            if 
                elementKind == UICollectionView.elementKindSectionHeader,
                let headerComponent = section.headerNode
            {
                let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: headerComponent.component.reuseIdentifier,
                    for: indexPath
                ) as! (UICollectionReusableView & ComponentRenderable)

                supplementaryView.render(
                    component: headerComponent.component,
                    renderType: .hard
                )

                return supplementaryView
            }

            if
                elementKind == UICollectionView.elementKindSectionFooter,
                let footerComponent = section.footerNode
            {
                let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: footerComponent.component.reuseIdentifier,
                    for: indexPath
                ) as! (UICollectionReusableView & ComponentRenderable)

                supplementaryView.render(
                    component: footerComponent.component,
                    renderType: .hard
                )

                return supplementaryView
            }

            return nil
        }
        // TODO: handle reorder items
        dataSource = customDataSource
        target.delegate = self
    }

    public func performUpdates(
        target: UICollectionView,
        sections: [ComponentSection],
        animationType: UpdaterAnimationType
    ) {
        // -----------------
        // | registrations |
        // -----------------

        // cells
        let allCellIdentifiers = sections.flatMap { $0.cellsNode }.map { $0.component.reuseIdentifier }
        allCellIdentifiers.forEach {
            target.register(ComponentCollectionViewCell.self, forCellWithReuseIdentifier: $0)
        }

        // headers
        let allHeaderIdentifiers = sections.compactMap { $0.headerNode?.component.reuseIdentifier }
        allHeaderIdentifiers.forEach {
            target.register(
                ComponentCollectionReusableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: $0
            )
        }

        // footers
        let allFooterIdentifiers = sections.compactMap { $0.footerNode?.component.reuseIdentifier }
        allFooterIdentifiers.forEach {
            target.register(
                ComponentCollectionReusableView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: $0
            )
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
                switch animationType {
                case .withAnimation, .automatic:
                    return dataSource.numberOfSections(in: target) != 0 && target.window != nil
                case .withoutAnimation:
                    return false
                }
            }()
        )

        // update visible components
        DispatchQueue.main.async {
            self.renderVisibleComponents(in: target)
        }
    }

    public func renderVisibleComponents(in target: Target) {
        // cells
        let itemsToSoftRender: [(cell: ComponentRenderable, componentNode: ComponentNode, indexPath: IndexPath)] = (target.indexPathsForVisibleItems ?? [])
            .compactMap { indexPath in
                if
                    let componentNode = dataSource.itemIdentifier(for: indexPath),
                    let cell = target.cellForItem(at: indexPath) as? ComponentRenderable
                {
                    return (cell: cell, componentNode: componentNode, indexPath: indexPath)
                }
                return nil
            }
        itemsToSoftRender.forEach {
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
                    let cell = target.cellForItem(at: indexPath) as? ComponentRenderable
                {
                    return (cell: cell, componentNode: componentNode, indexPath: indexPath)
                }
                return nil
            }
        itemsToHardRender.forEach {
            $0.cell.render(component: $0.componentNode.component, renderType: .hard)
        }

        // headers
        let sectionHeaderIndexes = Array(Set(target.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader).map { $0.section }))
        let headersToRender: [(header: ComponentRenderable, viewNode: ComponentNode, section: Int)] = sectionHeaderIndexes.compactMap { index in
            target
            guard
                let view = target.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionHeader,
                    at: .init(item: 0, section: index)
                ) as? ComponentRenderable,
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
        let sectionFooterIndexes = Array(Set(target.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter).map { $0.section }))
        let footersToRender: [(footer: ComponentRenderable, viewNode: ComponentNode, section: Int)] = sectionFooterIndexes.compactMap { index in
            guard
                let view = target.supplementaryView(
                    forElementKind: UICollectionView.elementKindSectionFooter,
                    at: .init(item: 0, section: index)
                ) as? ComponentRenderable,
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

    public func getCell(target: Target, componentId: AnyHashable) -> UIView? {
        guard let indexPath = dataSource.indexPath(for: .init(component: FakeComponent(id: componentId))) else {
            return nil
        }
        return target.cellForItem(at: indexPath)
    }

    public func getCell(tableView: Target, componentId: AnyHashable) -> UIView? {
        getCell(target: tableView, componentId: componentId)
    }

    // MARK: - UICollectionViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView as! UICollectionView)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let selectableComponent = componentNode.component as? (any SelectableComponent)
        else { return }
        selectableComponent.onSelect?()
        if selectableComponent.shouldDeselect {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let selectableComponent = componentNode.component as? (any SelectableComponent),
            selectableComponent.onSelect != nil
        else { return false }
        return true
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard
            let componentNode = dataSource.itemIdentifier(for: indexPath),
            let view = cell as? ComponentRenderable,
            let renderTarget = view.renderTarget
        else { return }
        AnyComponent(componentNode.component)
            .renderTargetWillDisplay(renderTarget)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        if 
            elementKind == UICollectionView.elementKindSectionHeader,
            let componentNode = dataSource.sectionIdentifier(
                for: indexPath.section
            )?.headerNode,
            let view = view as? ComponentRenderable,
            let renderTarget = view.renderTarget
        {
            AnyComponent(componentNode.component)
                .renderTargetWillDisplay(renderTarget)
        }

        if
            elementKind == UICollectionView.elementKindSectionFooter,
            let componentNode = dataSource.sectionIdentifier(
                for: indexPath.section
            )?.footerNode,
            let view = view as? ComponentRenderable,
            let renderTarget = view.renderTarget
        {
            AnyComponent(componentNode.component)
                .renderTargetWillDisplay(renderTarget)
        }
    }

}
