import UIKit

public protocol ComponentRenderable: AnyObject {
    var renderTarget: Any? { get set }
    var renderComponent: AnyComponent? { get set }
    var componentContainerView: UIView { get }
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

public extension ComponentRenderable {
    func render(component: any Component, renderType: RenderType) {
        let anyComponent = AnyComponent(component)
        if let renderTarget {
            // уже создана вьюха где должен рендерится компонент
            anyComponent.render(in: renderTarget, renderType: renderType)
            self.renderComponent = anyComponent
        } else {
            // вьюха еще не создана - нужно создать и залейаутить
            let renderTarget = anyComponent.createRenderTarget()
            anyComponent.layout(renderTarget: renderTarget, in: componentContainerView)
            anyComponent.render(in: renderTarget, renderType: renderType)

            self.renderTarget = renderTarget
            self.renderComponent = anyComponent
        }

        // TODO: реализвать shouldRender
    }
}
