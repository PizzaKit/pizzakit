import SnapKit
import UIKit
import PizzaKit

/// Отражает тип заполнения. Soft если элемент видим на экране и необходимо его
/// обновить с анимацией, hard в остальных случаях.
public enum RenderType {
    case hard, soft
}

/// Модель, которая в себе содержит все поля, необходимые для заполнения RenderTarget.
/// Так же модель (Component) ответственна за сравнение себя с новой моделью,
/// добавлением RenderTarget к контейнеру и отслеживает методы ЖЦ RenderTarget
/// RenderTarget - view, которая будет заполняться моделью (Component-ом).
public protocol Component<RenderTarget> {
    associatedtype RenderTarget

    var reuseIdentifier: String { get }

    /// Создает `RenderTarget` для последующего заполнения. Это делается не каждый раз,
    /// а только при необходимости. Если уже такой `RenderTarget` был создан,
    /// он будет переиспользоваться
    func createRenderTarget() -> RenderTarget
    /// Происходит заполнение ранее созданного или переиспользуемого RenderTarget-а
    /// с текущей моделью (компонентом).
    func render(in renderTarget: RenderTarget, renderType: RenderType)
    /// TODO: не очень понятно для чего нужен - мб удалить?
    func shouldRender(other component: Self, in renderTarget: RenderTarget) -> Bool
    func layout(renderTarget: RenderTarget, in container: UIView)
    func renderTargetWillDisplay(_ renderTarget: RenderTarget)
    func renderTargetDidEndDiplay(_ renderTarget: RenderTarget)

    func shouldHighlight() -> Bool
}

public extension Component {
    var reuseIdentifier: String {
        return String(reflecting: Self.self)
    }
    func shouldRender(other component: Self, in renderTarget: RenderTarget) -> Bool {
        return true
    }
    func renderTargetWillDisplay(_ renderTarget: RenderTarget) {}
    func renderTargetDidEndDiplay(_ renderTarget: RenderTarget) {}

    func shouldHighlight() -> Bool {
        return true
    }
}

public protocol IdentifiableComponent: Component {
    associatedtype ID: Hashable
    var id: ID { get }
}

public extension Component where RenderTarget: UIView {

    func layout(renderTarget: RenderTarget, in container: UIView) {
        renderTarget.do {
            container.addSubview($0)
            $0.snp.makeConstraints { make in
                make
                    .leading
                    .top
                    .equalToSuperview()
                make
                    .trailing
                    .bottom
                    .equalToSuperview()
                    .priority(999) // TODO: move to constants
            }
        }

    }

}