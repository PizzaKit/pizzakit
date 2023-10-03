import PizzaKit
import UIKit
import SnapKit

struct ToggleComponent: IdentifiableComponent, SelectableComponent, ComponentWithAccessories {

    let id: String
    let color: UIColor
    let colorText: String
    let title: String
    let value: String
    let isExpanded: Bool
    let onSelect: PizzaEmptyClosure?

    var shouldDeselect: Bool { false }

    func render(in renderTarget: ToggleComponentView, renderType: RenderType) {
        renderTarget.configure(
            color: color,
            colorText: colorText,
            title: title,
            value: value,
            isExpanded: isExpanded,
            renderType: renderType
        )
    }

    func createRenderTarget() -> RenderTarget {
        ToggleComponentView()
    }

    var accessories: [ComponentAccessoryType] {
        [.arrow]
    }

}

class ToggleComponentView: PizzaView {

    private let titleLabel = PizzaLabel()
    private let descriptionLabel = PizzaLabel()
    private let coloredView = UIView()
    private let coloredLabel = PizzaLabel()

    private var coloredViewWidthConstraint: Constraint?

    public override func commonInit() {
        super.commonInit()

        coloredView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                coloredViewWidthConstraint = make.width.equalTo(4).constraint
                make.height.equalTo(20)
            }
            $0.layer.cornerRadius = 2
            $0.layer.cornerCurve = .continuous
            $0.clipsToBounds = true
        }

        coloredLabel.do {
            coloredView.addSubview($0)
            $0.font = .systemFont(ofSize: 12, weight: .semibold).rounded
            $0.textColor = .systemBackground
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview().offset(-1)
                make.centerX.equalToSuperview()
                make.leading.equalToSuperview()
                    .offset(4)
                    .priority(.high)
            }
        }

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalTo(coloredView.snp.trailing).offset(8)
                make.top.bottom.equalToSuperview().inset(12)
            }
            $0.style = .allStyles.body(color: .palette.label, alignment: .left)
            $0.numberOfLines = 0
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }

        descriptionLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            }
            $0.style = .allStyles.body(color: .palette.labelSecondary, alignment: .right)
            $0.numberOfLines = 0
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    func configure(
        color: UIColor,
        colorText: String,
        title: String,
        value: String,
        isExpanded: Bool,
        renderType: RenderType
    ) {
        titleLabel.text = title
        descriptionLabel.text = value
        coloredView.backgroundColor = color
        coloredLabel.text = colorText

        coloredViewWidthConstraint?.isActive = !isExpanded

        let animationBlock: PizzaEmptyClosure = {
            self.superview?.layoutIfNeeded()
            self.coloredView.layer.cornerRadius = isExpanded ? 4 : 2
            self.coloredLabel.alpha = isExpanded ? 1 : 0
        }
        UIView.animateIfNeeded(
            duration: 0.2,
            needAnimate: renderType == .soft,
            animationBlock: animationBlock
        )
    }

}
