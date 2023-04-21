import UIKit
import PizzaDesign

public class FormTableViewCell: PizzaTableCell, ComponentRenderable {

    public var renderTarget: Any?
    public var renderComponent: AnyComponent?

    public override func commonInit() {
        super.commonInit()

        let customBackgroundView = UIView().do {
            $0.backgroundColor = UIColor(dynamicProvider: { trait in
                trait.userInterfaceLevel == .elevated
                    ? .systemGray4
                    : .systemGray5
            })
        }
        selectedBackgroundView = customBackgroundView
    }

}
