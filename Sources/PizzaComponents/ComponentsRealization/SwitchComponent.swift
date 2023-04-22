import PizzaDesign
import UIKit
import SnapKit
import PizzaCore

public struct SwitchComponent: IdentifiableComponent, ComponentWithSeparator {

    public struct Style {
        public let allowPressOnWholeCell: Bool
        public let allowHapticFeedback: Bool

        public init(
            allowPressOnWholeCell: Bool,
            allowHapticFeedback: Bool
        ) {
            self.allowPressOnWholeCell = allowPressOnWholeCell
            self.allowHapticFeedback = allowHapticFeedback
        }

        public static let `default` = Style(
            allowPressOnWholeCell: true,
            allowHapticFeedback: true
        )
    }

    public let id: String
    public let icon: ComponentIcon?
    public let text: String
    public let textStyle: UIStyle<UILabel>
    public let value: Bool
    public let style: Style
    public let isEnabled: Bool
    public let onChanged: PizzaClosure<Bool>

    public var separatorInsets: NSDirectionalEdgeInsets {
        icon == nil
            ? .zero
            : .init(top: 0, leading: 44, bottom: 0, trailing: 0)
    }

    public init(
        id: String,
        icon: ComponentIcon? = nil,
        text: String,
        textStyle: UIStyle<UILabel> = .bodyLabel(alignment: .left),
        value: Bool,
        style: Style = .default,
        isEnabled: Bool = true,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        self.id = id
        self.icon = icon
        self.text = text
        self.textStyle = textStyle
        self.value = value
        self.style = style
        self.isEnabled = isEnabled
        self.onChanged = onChanged
    }

    public func createRenderTarget() -> SwitchComponentView {
        return SwitchComponentView()
    }

    public func render(in renderTarget: SwitchComponentView, renderType: RenderType) {
        renderTarget.configure(
            icon: icon,
            text: text,
            textStyle: textStyle,
            isOn: value,
            style: style,
            isEnabled: isEnabled,
            animated: renderType == .soft,
            onChanged: onChanged
        )
    }

}

public class SwitchComponentView: PizzaView {

    private let iconView = ComponentIconView()
    private let switchView = UISwitch()
    private let titleLabel = UILabel()

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(handlePress)
    )
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private var onChanged: PizzaClosure<Bool>?
    private var feedbackGeneratorEnabled = false

    public override func commonInit() {
        super.commonInit()

        iconView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview()
                make.size.equalTo(29)
            }
        }

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
            $0.numberOfLines = 1
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }

        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
    }

    func configure(
        icon: ComponentIcon?,
        text: String,
        textStyle: UIStyle<UILabel>,
        isOn: Bool,
        style: SwitchComponent.Style,
        isEnabled: Bool,
        animated: Bool,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        // TODO support style
        self.onChanged = onChanged

        tapGestureRecognizer.isEnabled = style.allowPressOnWholeCell && isEnabled
        feedbackGeneratorEnabled = style.allowHapticFeedback

        if let icon {
            iconView.configure(icon: icon)
        }
        iconView.isHidden = icon == nil

        titleLabel.text = text
        textStyle.apply(for: titleLabel)

        switchView.setOn(isOn, animated: animated)
        switchView.isEnabled = isEnabled

        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(icon == nil ? 0 : 44)
        }
        UIView.animateIfNeeded(
            duration: 0.3,
            needAnimate: animated,
            animationBlock: {
                self.layoutIfNeeded()
            }
        )
    }

    @objc
    private func handlePress() {
        switchView.setOn(!switchView.isOn, animated: true)
        if feedbackGeneratorEnabled {
            feedbackGenerator.impactOccurred()
        }
        onChanged?(switchView.isOn)
    }

    @objc
    private func handleSwitchValueChanged() {
        onChanged?(switchView.isOn)
    }

}
