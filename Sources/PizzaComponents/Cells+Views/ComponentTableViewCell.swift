import UIKit
import PizzaDesign

public class ComponentTableViewCell: PizzaTableCell, ComponentRenderable {

    public var renderTarget: Any?
    public var renderComponent: AnyComponent?

    public override func commonInit() {
        super.commonInit()

        let customBackgroundView = UIView().do {
            $0.backgroundColor = UIColor(dynamicProvider: { trait in
                trait.userInterfaceLevel == .elevated && trait.userInterfaceStyle == .dark
                    ? .systemGray4
                    : .systemGray5
            })
        }
        selectedBackgroundView = customBackgroundView


    }

    public func postRenderConfiguration(component: any Component, renderType: RenderType) {
        if let accessoriesComponent = component as? ComponentWithAccessories {
            let accessories = accessoriesComponent.accessories
            if accessories.contains(.arrow) {
                self.accessoryType = .disclosureIndicator
            } else if accessories.contains(.check) {
                self.accessoryType = .checkmark
            } else {
                self.accessoryType = .none
            }
        } else {
            self.accessoryType = .none
        }

        if let separatorComponent = component as? ComponentWithSeparator {
            separatorInset = separatorComponent.separatorInsets.convertToUIEdgeInsets()
        } else {
            separatorInset = .zero
        }
    }

}
