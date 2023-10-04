import PizzaDesign
import PizzaCore
import UIKit
import SnapKit
import SFSafeSymbols

public struct ListComponent: IdentifiableComponent, SelectableComponent, ComponentWithSeparator, ComponentWithAccessories, ComponentWithSwipeActions {
    
    public enum TrailingContent {
        case arrow
        case check
        case info(onPress: PizzaEmptyClosure)
        case sfSymbol(SFSymbol)

        var sfSymbol: SFSymbol? {
            if case let .sfSymbol(symbol) = self {
                return symbol
            }
            return nil
        }
    }
    public enum ValuePosition {
        case trailing
        case bottom
    }
    public struct LabelsStyle {
        public let titleStyle: UIStyle<PizzaLabel>
        public let valueStyle: UIStyle<PizzaLabel>
        public let numberOfLines: Int

        public init(
            titleStyle: UIStyle<PizzaLabel> = .allStyles.body(
                color: .palette.label,
                alignment: .left
            ),
            valueStyle: UIStyle<PizzaLabel> = .allStyles.body(
                color: .palette.labelSecondary,
                alignment: .left
            ),
            numberOfLines: Int = 1
        ) {
            self.titleStyle = titleStyle
            self.valueStyle = valueStyle
            self.numberOfLines = numberOfLines
        }

        public static let defaultOneLine: LabelsStyle = .init(
            titleStyle: .allStyles.body(
                color: .palette.label,
                alignment: .left
            ),
            valueStyle: .allStyles.body(
                color: .palette.labelSecondary,
                alignment: .left
            ),
            numberOfLines: 1
        )
        public static let defaultMultipleLines: LabelsStyle = .init(
            titleStyle: .allStyles.body(
                color: .palette.label,
                alignment: .left
            ),
            valueStyle: .allStyles.body(
                color: .palette.labelSecondary,
                alignment: .left
            ),
            numberOfLines: 0
        )
        public static let multipleLinesSmallValue: LabelsStyle = .init(
            titleStyle: .allStyles.body(
                color: .palette.label,
                alignment: .left
            ),
            valueStyle: .allStyles.subhead(
                color: .palette.labelSecondary,
                alignment: .left
            ),
            numberOfLines: 0
        )
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
    public let labelsStyle: LabelsStyle
    public let valuePosition: ValuePosition
    public let selectableContext: SelectableContext?
    public let trailingContent: TrailingContent?
    public let leadingSwipeActions: [ComponentSwipeAction]
    public let trailingSwipeActions: [ComponentSwipeAction]
    public let allowAnimationsOnUpdate: Bool

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
        case .info(let onPress):
            return [.info(onPress: onPress)]
        case .check:
            return [.check]
        case .sfSymbol:
            return []
        }
    }

    public init(
        id: String,
        icon: ComponentIcon? = nil,
        title: String? = nil,
        value: String? = nil,
        labelsStyle: LabelsStyle = .defaultOneLine,
        valuePosition: ValuePosition = .trailing,
        selectableContext: SelectableContext? = nil,
        trailingContent: TrailingContent? = nil,
        leadingSwipeActions: [ComponentSwipeAction] = [],
        trailingSwipeActions: [ComponentSwipeAction] = [],
        allowAnimationsOnUpdate: Bool = true
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.value = value
        self.labelsStyle = labelsStyle
        self.valuePosition = valuePosition
        self.selectableContext = selectableContext
        self.trailingContent = trailingContent
        self.leadingSwipeActions = leadingSwipeActions
        self.trailingSwipeActions = trailingSwipeActions
        self.allowAnimationsOnUpdate = allowAnimationsOnUpdate
    }

    public func render(
        in renderTarget: ListBaseComponentView,
        renderType: RenderType
    ) {
        renderTarget.configure(
            icon: icon,
            title: title,
            value: value,
            labelsStyle: labelsStyle,
            trailingSFSymbol: trailingContent?.sfSymbol,
            animated: renderType == .soft && allowAnimationsOnUpdate
        )
    }

    public func createRenderTarget() -> ListBaseComponentView {
        if case .bottom = valuePosition, value?.nilIfEmpty != nil {
            return ListVerticalComponentView()
        }
        return ListHorizontalComponentView()
    }

}

public class ListBaseComponentView: PizzaView {

    let iconView = ComponentIconView()
    let titleLabel = PizzaLabel()
    let descriptionLabel = PizzaLabel()
    let trailingIconImageView = UIImageView()

    var iconCenterYConstraint: Constraint?
    var iconTopConstraint: Constraint?

    public override func commonInit() {
        super.commonInit()

        iconView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                iconCenterYConstraint = make.centerY.equalToSuperview().constraint
                iconTopConstraint = make.top.equalTo(titleLabel.snp.top).offset(3).constraint
                make.leading.equalToSuperview()
                make.size.equalTo(29)
            }
            iconCenterYConstraint?.deactivate()
            iconTopConstraint?.deactivate()
        }

        trailingIconImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalTo(iconView.snp.centerY)
                make.trailing.equalToSuperview()
                make.size.equalTo(24)
            }
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    public func configure(
        icon: ComponentIcon?,
        title: String?,
        value: String?,
        labelsStyle: ListComponent.LabelsStyle,
        trailingSFSymbol: SFSymbol?,
        animated: Bool
    ) {
        if let icon {
            iconView.configure(icon: icon)
        }
        iconView.isHidden = icon == nil

        if let trailingSFSymbol {
            trailingIconImageView.image = UIImage(
                systemSymbol: trailingSFSymbol,
                withConfiguration: UIImage.SymbolConfiguration(
                    hierarchicalColor: .tertiaryLabel
                )
            )
        }
        trailingIconImageView.isHidden = trailingSFSymbol == nil

        titleLabel.text = title
        titleLabel.style = labelsStyle.titleStyle
        titleLabel.numberOfLines = labelsStyle.numberOfLines

        descriptionLabel.text = value
        descriptionLabel.style = labelsStyle.valueStyle
        descriptionLabel.numberOfLines = labelsStyle.numberOfLines

        UIView.animateIfNeeded(
            duration: .animationConstants.standardDuration,
            needAnimate: animated,
            animationBlock: {
                self.layoutIfNeeded()
            }
        )
    }

}

public class ListHorizontalComponentView: ListBaseComponentView {

    public override func commonInit() {
        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
            }
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }

        descriptionLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            }
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        super.commonInit()
    }

    public override func configure(
        icon: ComponentIcon?,
        title: String?,
        value: String?,
        labelsStyle: ListComponent.LabelsStyle,
        trailingSFSymbol: SFSymbol?,
        animated: Bool
    ) {
        iconTopConstraint?.deactivate()
        iconCenterYConstraint?.activate()

        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(icon == nil ? 0 : 44)
        }

        descriptionLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(trailingSFSymbol == nil ? 0 : -32)
        }

        super.configure(
            icon: icon,
            title: title,
            value: value,
            labelsStyle: labelsStyle,
            trailingSFSymbol: trailingSFSymbol,
            animated: animated
        )
    }

}

public class ListVerticalComponentView: ListBaseComponentView {

    public override func commonInit() {
        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().inset(12)
            }
        }

        descriptionLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().inset(12)
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
            }
        }

        super.commonInit()
    }

    public override func configure(
        icon: ComponentIcon?,
        title: String?,
        value: String?,
        labelsStyle: ListComponent.LabelsStyle,
        trailingSFSymbol: SFSymbol?,
        animated: Bool
    )  {
        iconTopConstraint?.activate()
        iconCenterYConstraint?.deactivate()

        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(icon == nil ? 0 : 44)
            make.trailing.equalToSuperview().offset(trailingSFSymbol == nil ? 0 : -32)
        }
        descriptionLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(icon == nil ? 0 : 44)
            make.trailing.equalToSuperview().offset(trailingSFSymbol == nil ? 0 : -32)
        }

        super.configure(
            icon: icon,
            title: title,
            value: value,
            labelsStyle: labelsStyle,
            trailingSFSymbol: trailingSFSymbol,
            animated: animated
        )
    }

}
