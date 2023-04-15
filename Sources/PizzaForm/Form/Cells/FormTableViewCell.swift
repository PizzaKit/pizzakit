import UIKit
import PizzaKit

public class FormTableViewCell: PizzaTableCell, ComponentRenderable {

    public var renderTarget: Any?
    public var renderComponent: AnyComponent?

    public override func commonInit() {
        super.commonInit()

        let customBackgroundView = UIView().do {
            $0.backgroundColor = .systemGray5
        }
        selectedBackgroundView = customBackgroundView
    }

}
