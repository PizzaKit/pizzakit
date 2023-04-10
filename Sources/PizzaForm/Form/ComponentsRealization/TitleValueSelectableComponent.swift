import UIKit
import SnapKit
import PizzaKit

public struct TitleValueSelectableComponent: IdentifiableComponent, ComponentWithAccessories, SelectableComponent {

    public let id: String
    public let title: String?
    public let description: String?
    public let style: TitleValueComponent.Style
    public let onSelect: PizzaEmptyClosure?

    public var accessories: [ComponentAccessoryType] {
        return style.needArrow ? [.arrow] : []
    }

    public var shouldDeselect: Bool {
        return false
    }

    public init(
        id: String,
        title: String? = nil,
        description: String? = nil,
        style: TitleValueComponent.Style = .default,
        onSelect: PizzaEmptyClosure?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.style = style
        self.onSelect = onSelect
    }

    public func render(in renderTarget: TitleValueView, renderType: RenderType) {
        renderTarget.configure(
            title: title,
            description: description,
            style: style
        )
    }

    public func createRenderTarget() -> TitleValueView {
        return TitleValueView()
    }

}
