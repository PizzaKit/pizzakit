import UIKit
import PizzaKit

public class FormTableViewCell: PizzaTableCell, ComponentRenderable {

    public var renderTarget: Any?
    public var renderComponent: AnyComponent?

    public override func commonInit() {
        super.commonInit()

//        selectionStyle = .none
//        accessoryType = .detailDisclosureButton

//        separatorInset = .init(top: 0, left: 50, bottom: 0, right: 0) // TODO: change
    }

//    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        if highlighted {
//            print("is highlighted")
//        }
//    }

}
