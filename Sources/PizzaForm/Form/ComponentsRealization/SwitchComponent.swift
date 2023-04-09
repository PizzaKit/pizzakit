import PizzaKit
import UIKit
import SnapKit

public struct SwitchComponent: IdentifiableComponent {
    public init(
        id: String,
        text: String,
        value: Bool,
        isEnabled: Bool,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        self.id = id
        self.text = text
        self.value = value
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }


    public let id: String
    public let text: String
    public let value: Bool
    public let isEnabled: Bool
    public let onChanged: PizzaClosure<Bool>

    public func createRenderTarget() -> ViewWithSwitch {
        return ViewWithSwitch()
    }

    public func render(in renderTarget: ViewWithSwitch, renderType: RenderType) {
        renderTarget.configure(
            text: text,
            isOn: value,
            isEnabled: isEnabled,
            animated: renderType == .soft,
            onChanged: onChanged
        )
    }

}

public class ViewWithSwitch: PizzaView {

    private let switchView = UISwitch()
    private let titleLabel = UILabel()

    private var onChanged: PizzaClosure<Bool>?

    public override func commonInit() {
        super.commonInit()

        switchView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0.addTarget(self, action: #selector(handleSwitchValueChanged), for: .valueChanged)
        }

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.bottom.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalTo(switchView.snp.leading).offset(-10)
            }
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .label
            $0.textAlignment = .natural
            $0.numberOfLines = 0
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    func configure(
        text: String,
        isOn: Bool,
        isEnabled: Bool,
        animated: Bool,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        self.onChanged = onChanged
        titleLabel.text = text
        switchView.setOn(isOn, animated: animated)
        switchView.isEnabled = isEnabled
    }

    @objc
    private func handleSwitchValueChanged() {
        onChanged?(switchView.isOn)
    }

}
