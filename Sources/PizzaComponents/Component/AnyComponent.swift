import UIKit

/// Type erasure for Component
public struct AnyComponent: Component {

    let box: any AnyComponentBox

    public init<Base: Component>(_ base: Base) {
        if let anyComponent = base as? AnyComponent {
            self = anyComponent
        }
        else {
            box = ComponentBox(base)
        }
    }

    public func createRenderTarget() -> Any {
        box.createRenderTarget()
    }

    public func render(in renderTarget: Any, renderType: RenderType) {
        box.render(in: renderTarget, renderType: renderType)
    }

    public func layout(renderTarget: Any, in container: UIView) {
        box.layout(renderTarget: renderTarget, in: container)
    }

    public func renderTargetWillDisplay(_ renderTarget: Any) {
        box.renderTargetWillDisplay(renderTarget)
    }

    public func renderTargetDidEndDiplay(_ renderTarget: Any) {
        box.renderTargetDidEndDiplay(renderTarget)
    }

}

struct ComponentBox<Base: Component>: AnyComponentBox {

    var base: Any {
        return baseComponent
    }

    let baseComponent: Base
    init(_ base: Base) {
        baseComponent = base
    }

    func createRenderTarget() -> Any {
        baseComponent.createRenderTarget()
    }

    func render(in renderTarget: Any, renderType: RenderType) {
        guard let renderTarget = renderTarget as? Base.RenderTarget else { return }
        return baseComponent.render(in: renderTarget, renderType: renderType)
    }

    func layout(renderTarget: Any, in container: UIView) {
        guard let renderTarget = renderTarget as? Base.RenderTarget else { return }
        return baseComponent.layout(renderTarget: renderTarget, in: container)
    }

    func renderTargetWillDisplay(_ renderTarget: Any) {
        guard let renderTarget = renderTarget as? Base.RenderTarget else { return }
        return baseComponent.renderTargetWillDisplay(renderTarget)
    }

    func renderTargetDidEndDiplay(_ renderTarget: Any) {
        guard let renderTarget = renderTarget as? Base.RenderTarget else { return }
        return baseComponent.renderTargetDidEndDiplay(renderTarget)
    }
}

internal protocol AnyComponentBox {
    var base: Any { get }

    func createRenderTarget() -> Any
    func render(in renderTarget: Any, renderType: RenderType)
    func layout(renderTarget: Any, in container: UIView)
    func renderTargetWillDisplay(_ renderTarget: Any)
    func renderTargetDidEndDiplay(_ renderTarget: Any)
}
