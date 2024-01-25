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

    public enum DisplayType {
        case enabled
        case disabledNative
        case disabledLock
    }

    public let id: String
    public let icon: PizzaIcon?
    public let text: String
    public let textStyle: UIStyle<PizzaLabel>
    public let value: Bool
    public let style: Style
    public let displayType: DisplayType
    public let onChanged: PizzaClosure<Bool>

    public var separatorInsets: NSDirectionalEdgeInsets {
        icon == nil
            ? .zero
            : .init(top: 0, leading: 44, bottom: 0, trailing: 0)
    }

    @available(*, deprecated, message: "instead of isEnabled use displayType")
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
        self.displayType = isEnabled ? .enabled : .disabledNative
        self.onChanged = onChanged
    }

    public init(
        id: String,
        icon: PizzaIcon? = nil,
        text: String,
        textStyle: UIStyle<PizzaLabel> = .allStyles.body(color: .palette.label, alignment: .left),
        value: Bool,
        style: Style = .defaultOneLine,
        displayType: DisplayType,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        self.id = id
        self.icon = icon
        self.text = text
        self.textStyle = textStyle
        self.value = value
        self.style = style
        self.displayType = displayType
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
            displayType: displayType,
            animated: renderType == .soft,
            onChanged: onChanged
        )
    }

}

class SwitchLockOverlayView: PizzaView {

    private var switchView: UISwitch? {
        didSet {
            updateHandler(old: oldValue)
        }
    }

    private let lockImageViewOn = UIImageView()
    private let lockImageViewOff = UIImageView()

    private var passthroughView = PizzaPassthroughView()

    private var onTap: PizzaEmptyClosure?

    override func commonInit() {
        super.commonInit()

        lockImageViewOn.do {
            addSubview($0)
            $0.image = UIImage(systemSymbol: .lockFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: 10))
            $0.tintColor = .white
            $0.snp.makeConstraints { make in
                make.centerY.equalTo(snp.centerY)
                make.centerX.equalTo(snp.centerX).offset(-12)
            }
        }

        lockImageViewOff.do {
            addSubview($0)
            $0.image = UIImage(systemSymbol: .lockFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: 10))
            $0.tintColor = .systemGray
            $0.snp.makeConstraints { make in
                make.centerY.equalTo(snp.centerY)
                make.centerX.equalTo(snp.centerX).offset(12)
            }
        }

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    func configure(switchView: UISwitch) {
        self.switchView = switchView
    }

    func setNeedsSyncSwitchState() {
        lockImageViewOn.isHidden = switchView?.isOn != true
        lockImageViewOff.isHidden = switchView?.isOn == true
    }

    func configure(onTap: PizzaEmptyClosure?) {
        self.onTap = onTap
    }

    private func updateHandler(old: UISwitch?) {

        setNeedsSyncSwitchState()

        old?.removeTarget(self, action: #selector(handleSwitchValueChanged), for: .valueChanged)
        switchView?.addTarget(self, action: #selector(handleSwitchValueChanged), for: .valueChanged)
    }

    @objc
    private func handleSwitchValueChanged() {
        setNeedsSyncSwitchState()
    }

    @objc
    private func handleTap() {
        onTap?()
    }

}

public class SwitchComponentView: PizzaView {

    private let iconView = PizzaIconView()
    private let switchView = UISwitch()
    private let titleLabel = PizzaLabel()
    private let switchOverlay = SwitchLockOverlayView()

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(handlePress)
    )
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private var onChanged: PizzaClosure<Bool>?
    private var feedbackGeneratorEnabled = false
    private var allowToggleSwitchOnPress = false

    public override func commonInit() {
        super.commonInit()

        iconView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview()
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

        switchOverlay.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(switchView)
            }
            $0.configure(switchView: switchView)
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
        displayType: SwitchComponent.DisplayType,
        animated: Bool,
        onChanged: @escaping PizzaClosure<Bool>
    ) {
        self.onChanged = onChanged

        tapGestureRecognizer.isEnabled = style.allowPressOnWholeCell
        feedbackGeneratorEnabled = style.allowHapticFeedback
        allowToggleSwitchOnPress = displayType == .enabled
        switch displayType {
        case .enabled, .disabledNative:
            switchOverlay.isHidden = true
        case .disabledLock:
            switchOverlay.isHidden = false
            switchOverlay.configure(onTap: { [weak self] in
                self?.handlePress()
            })
        }

        if let icon {
            iconView.configure(icon: icon, shouldBounce: false)
        }
        iconView.isHidden = icon == nil

        titleLabel.numberOfLines = style.numberOfLines
        titleLabel.text = text
        titleLabel.style = textStyle

        switchView.setOn(isOn, animated: animated)
        switchView.isEnabled = displayType != .disabledNative
        switchOverlay.setNeedsSyncSwitchState()

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
        if allowToggleSwitchOnPress {
            switchView.setOn(!switchView.isOn, animated: true)
        }
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
