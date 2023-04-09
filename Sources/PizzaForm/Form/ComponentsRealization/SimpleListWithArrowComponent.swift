import UIKit
import PizzaKit

public struct SimpleListWithArrowComponent: IdentifiableComponent, SelectableComponent, ComponentWithAccessories {

    public let id: String

    public let iconName: String
    public let iconBackgroundColor: UIColor
    public let title: String?

    public let onSelect: PizzaEmptyClosure?
    public var shouldDeselect: Bool { return false }

    public var accessories: [ComponentAccessoryType] {
        [.arrow]
    }

    public init(
        id: String,
        iconName: String,
        iconBackgroundColor: UIColor,
        title: String?,
        onSelect: PizzaEmptyClosure?
    ) {
        self.id = id
        self.iconName = iconName
        self.iconBackgroundColor = iconBackgroundColor
        self.title = title
        self.onSelect = onSelect
    }

    public func createRenderTarget() -> SimpleListView {
        SimpleListView()
    }

    public func render(in renderTarget: SimpleListView, renderType: RenderType) {
        renderTarget.configure(
            image: .generateSettingsIcon(
                iconSystemName: iconName,
                iconColor: .white,
                iconFontSize: 16,
                backgroundSystemName: "app.fill",
                backgroundColor: iconBackgroundColor,
                backgroundFontSize: 32
            ),
            title: title
        )
    }

    public static var separatorInsets: UIEdgeInsets {
        .init(top: 0, left: 44, bottom: 0, right: 0)
    }
    
}

public class SimpleListView: PizzaView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    public override func commonInit() {
        super.commonInit()

        iconImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(29)
            }
            $0.contentMode = .center
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(16)
                make.top.bottom.equalToSuperview().inset(12)
                make.trailing.equalToSuperview()
            }
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    }

    func configure(
        image: UIImage?,
        title: String?
    ) {
        iconImageView.image = image
        titleLabel.text = title
    }

}
