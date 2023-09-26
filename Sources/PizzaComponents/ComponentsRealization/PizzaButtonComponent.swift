import UIKit
import SnapKit
import PizzaDesign
import PizzaCore

public struct PizzaButtonComponent: IdentifiableComponent {

    public let id: String
    public let buttonStyle: UIStyle<UIButton>
    public let onPress: PizzaEmptyClosure?
    public let needComponentBackground: Bool
    public let isEnabled: Bool

    public init(
        id: String,
        buttonStyle: UIStyle<UIButton>,
        onPress: PizzaEmptyClosure?,
        needComponentBackground: Bool = false,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.buttonStyle = buttonStyle
        self.onPress = onPress
        self.needComponentBackground = needComponentBackground
        self.isEnabled = isEnabled
    }

    public func createRenderTarget() -> PizzaButtonComponentView {
        PizzaButtonComponentView()
    }

    public func render(in renderTarget: PizzaButtonComponentView, renderType: RenderType) {
        renderTarget.configure(
            style: buttonStyle,
            onPress: onPress,
            needComponentBackground: needComponentBackground,
            isEnabled: isEnabled
        )
    }

    public var layoutType: ComponentLayoutType {
        .withoutMargins
    }

}

public class PizzaButtonComponentView: PizzaView {

    private let button = UIButton()

    private var onPress: PizzaEmptyClosure?

    private var savedColor: UIColor?

    public override func commonInit() {
        super.commonInit()

        button.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                    .inset(UIEdgeInsets(horizontal: 0, vertical: 6))
            }
            $0.addTarget(
                self,
                action: #selector(handleButtonPress),
                for: .touchUpInside
            )
        }

    }

    func configure(
        style: UIStyle<UIButton>,
        onPress: PizzaEmptyClosure?,
        needComponentBackground: Bool,
        isEnabled: Bool
    ) {
        self.onPress = onPress
        button.apply(style: style)
        button.isEnabled = isEnabled

        if needComponentBackground {
            if let savedColor {
                let tableViewCell: UITableViewCell? = self.traverseAndFindClass()
                tableViewCell?.backgroundColor = savedColor
            }
        } else {
            let tableViewCell: UITableViewCell? = self.traverseAndFindClass()
            savedColor = tableViewCell?.backgroundColor
            tableViewCell?.backgroundColor = .clear
        }
    }

    @objc
    private func handleButtonPress() {
        onPress?()
    }

}
