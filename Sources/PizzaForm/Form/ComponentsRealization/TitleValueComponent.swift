import UIKit
import SnapKit
import PizzaKit

public struct TitleValueComponent: IdentifiableComponent, ComponentWithAccessories {

    public struct Style {
        public init(titleColor: UIColor, valueColor: UIColor, needArrow: Bool) {
            self.titleColor = titleColor
            self.valueColor = valueColor
            self.needArrow = needArrow
        }

        public let titleColor: UIColor
        public let valueColor: UIColor
        public let needArrow: Bool

        public static let `default` = Style(
            titleColor: .label,
            valueColor: .secondaryLabel,
            needArrow: false
        )

        public static let defaultArrow = Style(
            titleColor: .label,
            valueColor: .secondaryLabel,
            needArrow: true
        )
    }

    public let id: String
    public let title: String?
    public let description: String?
    public let style: Style

    public var accessories: [ComponentAccessoryType] {
        return style.needArrow ? [.arrow] : []
    }

    public init(
        id: String,
        title: String? = nil,
        description: String? = nil,
        style: Style = .default
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.style = style
    }

    public func render(in renderTarget: TitleValueView, renderType: RenderType) {
        renderTarget.configure(
            title: title,
            description: description,
            style: style
        )
    }

    public func createRenderTarget() -> TitleValueView {
        return TitleValueView()
    }

}

public class TitleValueView: PizzaView {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    public override func commonInit() {
        super.commonInit()

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
            }
            $0.font = .systemFont(ofSize: 17)
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }

        descriptionLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(12)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            }
            $0.font = .systemFont(ofSize: 17)
            $0.textAlignment = .right
            $0.numberOfLines = 0
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    func configure(
        title: String?,
        description: String?,
        style: TitleValueComponent.Style
    ) {
        titleLabel.textColor = style.titleColor
        descriptionLabel.textColor = style.valueColor

        titleLabel.text = title
        descriptionLabel.text = description
    }

}
