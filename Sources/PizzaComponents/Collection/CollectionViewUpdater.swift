import UIKit
import PizzaCore

private class CustomDataSource: UICollectionViewDiffableDataSource<ComponentSection, ComponentNode> {

}

public class CollectionViewUpdater: NSObject, Updater, UICollectionViewDelegate {

    public typealias Target = UICollectionView
    private(set) public var dataSource: UICollectionViewDiffableDataSource<ComponentSection, ComponentNode>!

    // MARK: - Updater

    public var updaterDelegate: UpdaterDelegate?
    public var onScrollViewDidScroll: PizzaClosure<Target>?

    public func initialize(target: Target) {
        let customDataSource = CustomDataSource(
            collectionView: target
        ) { collectionView, indexPath, componentNode in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: componentNode.component.reuseIdentifier,
                for: indexPath
            ) as! (UICollectionViewCell & ComponentRenderable)

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

    public func performUpdates(target: Target, sections: [ComponentSection]) {
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
                return dataSource.numberOfSections(in: target) != 0 && target.window != nil
            }()
        )

        guard target.window != nil else { return }

        // update visible components
        DispatchQueue.main.async {
            self.renderVisibleComponents(in: target)
        }
    }

    public func renderVisibleComponents(in target: Target) {
        // cells
        let itemsToRender: [(cell: ComponentRenderable, componentNode: ComponentNode, indexPath: IndexPath)] = (target.indexPathsForVisibleItems ?? [])
            .compactMap { indexPath in
                if
                    let componentNode = dataSource.itemIdentifier(for: indexPath),
                    let cell = target.cellForItem(at: indexPath) as? ComponentRenderable
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
        let footersToRender: [(footer: ComponentRenderable, viewNode: ComponentNode, section: Int)] = sectionIndexes.compactMap { index in
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
