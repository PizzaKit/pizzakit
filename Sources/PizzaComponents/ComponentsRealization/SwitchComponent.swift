import PizzaDesign
import UIKit
import SnapKit
import PizzaCore
import PizzaIcon

public struct SwitchComponent: IdentifiableComponent, ComponentWithSeparator {

    public struct Style {
        public let allowPressOnWholeCell: Bool
        public let allowHapticFeedback: Bool
        public let numberOfLines: Int

        public init(
            allowPressOnWholeCell: Bool,
            allowHapticFeedback: Bool,
            numberOfLines: Int
        ) {
            self.allowPressOnWholeCell = allowPressOnWholeCell
            self.allowHapticFeedback = allowHapticFeedback
            self.numberOfLines = numberOfLines
        }

        public static let defaultOneLine = Style(
            allowPressOnWholeCell: true,
            allowHapticFeedback: true,
            numberOfLines: 1
        )

        public static let defaultMultipleLines = Style(
            allowPressOnWholeCell: true,
            allowHapticFeedback: true,
            numberOfLines: 0
        )
    }

    public let id: String
    public let icon: PizzaIcon?
    public let text: String
    public let textStyle: UIStyle<PizzaLabel>
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
        icon: PizzaIcon? = nil,
        text: String,
        textStyle: UIStyle<PizzaLabel> = .allStyles.body(color: .palette.label, alignment: .left),
        value: Bool,
        style: Style = .defaultOneLine,
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

    private let iconView = PizzaIconView()
    private let switchView = UISwitch()
    private let titleLabel = PizzaLabel()

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
//                make.size.equalTo(29)
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
                make.bottom.top.equalToSuperview().inset(10)
                make.leading.equalToSuperview()
                make.trailing.equalTo(switchView.snp.leading).offset(-10)
            }
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }

        addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
    }

    func configure(
        icon: PizzaIcon?,
        text: String,
        textStyle: UIStyle<PizzaLabel>,
        isOn: Bool,
        style: SwitchComponent.Style,
        isEnabled: Bool,
        animated: Bool,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        self.onChanged = onChanged

        tapGestureRecognizer.isEnabled = style.allowPressOnWholeCell && isEnabled
        feedbackGeneratorEnabled = style.allowHapticFeedback

        if let icon {
            iconView.configure(icon: icon, shouldBounce: false)
        }
        iconView.isHidden = icon == nil

        titleLabel.numberOfLines = style.numberOfLines
        titleLabel.text = text
        titleLabel.style = textStyle

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
