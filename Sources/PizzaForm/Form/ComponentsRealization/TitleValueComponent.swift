import UIKit
import SnapKit
import PizzaKit

public struct TitleValueComponent: IdentifiableComponent, ComponentWithAccessories {

    public let id: String
    public let title: String?
    public let description: String?
    public let needArrow: Bool

    public var accessories: [ComponentAccessoryType] {
        return needArrow ? [.arrow] : []
    }

    public init(
        id: String,
        title: String? = nil,
        description: String? = nil,
        needArrow: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.needArrow = needArrow
    }

    public func render(in renderTarget: TitleValueView, renderType: RenderType) {
        renderTarget.configure(title: title, description: description)
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
                make.top.bottom.equalToSuperview().inset(10)
            }
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .left
            $0.textColor = .label
            $0.numberOfLines = 0
        }

        descriptionLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(10)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.leading).offset(10)
            }
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .right
            $0.textColor = .tertiaryLabel
            $0.numberOfLines = 0
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    func configure(title: String?, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }

}
