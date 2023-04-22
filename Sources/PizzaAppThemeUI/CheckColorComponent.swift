import PizzaForm
import PizzaCore
import UIKit

struct CheckColorComponent: IdentifiableComponent, SelectableComponent, ComponentWithAccessories {

    let id: String
    let title: String
    let color: UIColor
    let isChecked: Bool
    let onSelect: PizzaEmptyClosure?

    var accessories: [ComponentAccessoryType] {
        isChecked ? [.check] : []
    }

    var shouldDeselect: Bool { true }

    func render(in renderTarget: SimpleListView, renderType: RenderType) {
        renderTarget.configure(title: title)
        renderTarget.iconView.configure(
            icon: nil,
            background: .init(
                iconSystemName: "app.fill",
                iconColor: color,
                iconFontSize: 32
            )
        )
    }

    func createRenderTarget() -> SimpleListView {
        SimpleListView()
    }

}
