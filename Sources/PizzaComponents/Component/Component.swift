import SnapKit
import UIKit
import PizzaCore

/// Отражает тип заполнения. Soft если элемент видим на экране и необходимо его
/// обновить с анимацией, hard в остальных случаях.
public enum RenderType {
    case hard, soft
}

public enum ComponentLayoutType {
    case layoutMargin
    case withoutMargins
}

public enum ComponentAccessoryType {
    case arrow, check
}

public protocol ComponentWithAccessories {
    var accessories: [ComponentAccessoryType] { get }
}

public protocol ComponentWithSeparator {
    var separatorInsets: NSDirectionalEdgeInsets { get }
}

/// Модель, которая в себе содержит все поля, необходимые для заполнения RenderTarget.
/// Так же модель (Component) ответственна за сравнение себя с новой моделью,
/// добавлением RenderTarget к контейнеру и отслеживает методы ЖЦ RenderTarget
/// RenderTarget - view, которая будет заполняться моделью (Component-ом).
public protocol Component<RenderTarget> {
    associatedtype RenderTarget

    /// Идентификатор для реюза ячеек (одинаковые компоненты будут реюзать одинаковые ячейки -
    /// для того, чтобы редко создавать RenderTarget - только один раз)
    var reuseIdentifier: String { get }

    /// Стандартный тип layout-а компонента в ячейки
    var layoutType: ComponentLayoutType { get }

    /// Создает `RenderTarget` для последующего заполнения. Это делается не каждый раз,
    /// а только при необходимости. Если уже такой `RenderTarget` был создан,
    /// он будет переиспользоваться
    func createRenderTarget() -> RenderTarget

    /// Происходит layout созданного renderTarget-а в контейнере
    func layout(renderTarget: RenderTarget, in container: UIView)

    /// Происходит заполнение ранее созданного или переиспользуемого RenderTarget-а
    /// с текущей моделью (компонентом).
    func render(in renderTarget: RenderTarget, renderType: RenderType)

    func renderTargetWillDisplay(_ renderTarget: RenderTarget)

    func renderTargetDidEndDiplay(_ renderTarget: RenderTarget)

    func renderTargetSetHighlight(
        _ renderTarget: RenderTarget,
        isHighlight: Bool,
        animated: Bool
    )
}

public extension Component {
    var reuseIdentifier: String {
        return String(reflecting: Self.self)
    }
    var layoutType: ComponentLayoutType {
        .layoutMargin
    }
    func renderTargetWillDisplay(_ renderTarget: RenderTarget) {}
    func renderTargetDidEndDiplay(_ renderTarget: RenderTarget) {}
    func renderTargetSetHighlight(
        _ renderTarget: RenderTarget,
        isHighlight: Bool,
        animated: Bool
    ) {}
}

public protocol IdentifiableComponent: Component {
    associatedtype ID: Hashable
    var id: ID { get }
}

public protocol SelectableComponent: Component {
    var onSelect: PizzaEmptyClosure? { get }
    var shouldDeselect: Bool { get }
}

public extension Component where RenderTarget: UIView {

    func layout(renderTarget: RenderTarget, in container: UIView) {
        switch layoutType {
        case .layoutMargin:
            renderTarget.do {
                container.addSubview($0)
                $0.snp.makeConstraints { make in
                    make
                        .top
                        .equalToSuperview()
                    make.leading.equalTo(container.layoutMarginsGuide.snp.leading)
                    make
                        .bottom
                        .equalToSuperview()
                        .priority(999)
                    make
                        .trailing
                        .equalTo(container.layoutMarginsGuide.snp.trailing)
                        .priority(999)
                }
            }
        case .withoutMargins:
            renderTarget.do {
                container.addSubview($0)
                $0.snp.makeConstraints { make in
                    make
                        .top
                        .equalToSuperview()
                    make.leading.equalToSuperview()
                    make
                        .bottom
                        .equalToSuperview()
                        .priority(999)
                    make
                        .trailing
                        .equalToSuperview()
                        .priority(999)
                }
            }
        }
    }

}
