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

    /// Method for making any postprocess configurations
    func postRenderConfiguration(component: any Component, renderType: RenderType)
}

public extension ComponentRenderable {
    func postRenderConfiguration(component: any Component, renderType: RenderType) {}
}

//public protocol ComponentRenderableAccessories {
//    func setup(accessories: [ComponentAccessoryType])
//}

public extension ComponentRenderable where Self: UITableViewCell {
    var componentContainerView: UIView {
        return contentView
    }
}
//extension UITableViewCell: ComponentRenderableAccessories {
//    public func setup(accessories: [ComponentAccessoryType]) {
//
//    }
//}
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
            /// 1. Создаем новый renderTarget
            /// 2. Если таргет есть и он нужного типа, то возвращаем его же
            /// 3. Иначе
            ///   - удаляем старый renderTarget из иерархии view
            ///   - layout-им новый renderTarget
            let newRenderTarget = anyComponent.createRenderTarget()
            if let renderTarget, type(of: renderTarget) == type(of: newRenderTarget) {
                return renderTarget
            }
            (renderTarget as? UIView)?.removeFromSuperview() // TODO: перенести эту логику в протокол компонента
            anyComponent.layout(renderTarget: newRenderTarget, in: componentContainerView)
            return newRenderTarget
        }()
        anyComponent.render(in: currentRenderTarget, renderType: renderType)

        self.renderTarget = currentRenderTarget
        self.renderComponent = anyComponent

        postRenderConfiguration(component: component, renderType: renderType)
    }
}
