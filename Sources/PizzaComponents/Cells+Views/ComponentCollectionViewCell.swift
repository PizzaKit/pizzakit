import UIKit

public class ComponentCollectionViewCell: UICollectionViewListCell, ComponentRenderable {

    public var renderTarget: Any?
    public var renderComponent: AnyComponent?

    public override var isHighlighted: Bool {
        didSet {
            guard let renderTarget else { return }
            renderComponent?.renderTargetSetHighlight(
                renderTarget,
                isHighlight: isHighlighted,
                animated: false
            )
        }
    }

    public func postRenderConfiguration(component: any Component, renderType: RenderType) {
        backgroundConfiguration = .clear()
    }

}
