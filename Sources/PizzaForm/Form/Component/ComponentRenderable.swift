import UIKit

/// Entity where component will be rendered
public protocol ComponentRenderable: AnyObject {
    /// View, which filled with component
    var renderTarget: Any? { get set }

    /// Rendered component with erased type
    var renderComponent: AnyComponent? { get set }

    /// Container that holds rendered component
    var componentContainerView: UIView { get }

    /// Method for rendering component in current entity
    func render(component: any Component, renderType: RenderType)
}

public extension ComponentRenderable where Self: UITableViewCell {
    var componentContainerView: UIView {
        return contentView
    }
}
public extension ComponentRenderable where Self: UICollectionViewCell {
    var componentContainerView: UIView {
        return contentView
    }
}
public extension ComponentRenderable where Self: UITableViewHeaderFooterView {
    var componentContainerView: UIView {
        return contentView
    }
}

public extension ComponentRenderable {
    func render(component: any Component, renderType: RenderType) {
        let anyComponent = AnyComponent(component)

        /// получаем render target или создаем новый
        let currentRenderTarget = {
            if let renderTarget {
                return renderTarget
            }
            let newRenderTarget = anyComponent.createRenderTarget()
            anyComponent.layout(renderTarget: newRenderTarget, in: componentContainerView)
            return newRenderTarget
        }()
        anyComponent.render(in: currentRenderTarget, renderType: renderType)

        self.renderTarget = currentRenderTarget
        self.renderComponent = anyComponent
    }
}
