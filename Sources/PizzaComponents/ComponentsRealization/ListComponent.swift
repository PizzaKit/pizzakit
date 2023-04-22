import PizzaDesign
import PizzaCore
import UIKit

public struct ListComponent: IdentifiableComponent, SelectableComponent, ComponentWithSeparator, ComponentWithAccessories {

    public enum TrailingContent {
        case arrow
        case check
    }
    public struct SelectableContext {
        public let shouldDeselect: Bool
        public let onSelect: PizzaEmptyClosure?

        public init(shouldDeselect: Bool, onSelect: PizzaEmptyClosure?) {
            self.shouldDeselect = shouldDeselect
            self.onSelect = onSelect
        }
    }

    public let id: String
    public let icon: ComponentIcon?
    public let title: String?
    public let value: String?
    public let titleStyle: UILabelStyle
    public let valueStyle: UILabelStyle
    public let selectableContext: SelectableContext?
    public let trailingContent: TrailingContent?

    public var onSelect: PizzaEmptyClosure? {
        selectableContext?.onSelect
    }
    public var shouldDeselect: Bool {
        selectableContext?.shouldDeselect ?? true
    }
    public var separatorInsets: NSDirectionalEdgeInsets {
        icon == nil
            ? .zero
            : .init(top: 0, leading: 44, bottom: 0, trailing: 0)
    }
    public var accessories: [ComponentAccessoryType] {
        guard let trailingContent else { return [] }
        switch trailingContent {
        case .arrow:
            return [.arrow]
        case .check:
            return [.check]
        }
    }

    public init(
        id: String,
        icon: ComponentIcon? = nil,
        title: String? = nil,
        value: String? = nil,
        titleStyle: UILabelStyle = .bodyLabel(alignment: .left),
        valueStyle: UILabelStyle = .bodyLabelSecondary(alignment: .right),
        selectableContext: SelectableContext? = nil,
        trailingContent: TrailingContent? = nil
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.value = value
        self.titleStyle = titleStyle
        self.valueStyle = valueStyle
        self.selectableContext = selectableContext
        self.trailingContent = trailingContent
    }

    public func render(in renderTarget: ListComponentView, renderType: RenderType) {
        renderTarget.configure(
            icon: icon,
            title: title,
            value: value,
            titleStyle: titleStyle,
            valueStyle: valueStyle,
            animated: renderType == .soft
        )
    }

    public func createRenderTarget() -> ListComponentView {
        ListComponentView()
    }

}

public class ListComponentView: PizzaView {

    private let iconView = ComponentIconView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

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

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
            }
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.numberOfLines = 1
        }

        descriptionLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            }
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.numberOfLines = 1
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    public func configure(
        icon: ComponentIcon?,
        title: String?,
        value: String?,
        titleStyle: UILabelStyle,
        valueStyle: UILabelStyle,
        animated: Bool
    ) {
        if let icon {
            iconView.configure(icon: icon)
        }
        iconView.isHidden = icon == nil

        titleLabel.text = title
        titleStyle.apply(for: titleLabel)

        descriptionLabel.text = value
        valueStyle.apply(for: descriptionLabel)

        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(icon == nil ? 0 : 44)
        }
        UIView.animateIfNeeded(
            duration: .designSystem.animationDuration,
            needAnimate: animated,
            animationBlock: {
                self.layoutIfNeeded()
            }
        )
    }

}
