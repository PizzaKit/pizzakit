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

    public override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layoutMargins = .init(horizontal: 20, vertical: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func postRenderConfiguration(component: any Component, renderType: RenderType) {
        backgroundConfiguration = .clear()
    }

}
