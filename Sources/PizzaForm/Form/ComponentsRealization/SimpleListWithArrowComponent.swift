import UIKit
import PizzaDesign
import PizzaCore

public struct SimpleListWithArrowComponent: IdentifiableComponent, SelectableComponent, ComponentWithAccessories {

    public let id: String

    public let iconName: String
    public let iconBackgroundColor: UIColor
    public let title: String?
    public let shouldDeselect: Bool

    public let onSelect: PizzaEmptyClosure?

    public var accessories: [ComponentAccessoryType] {
        [.arrow]
    }

    public init(
        id: String,
        iconName: String,
        iconBackgroundColor: UIColor,
        title: String?,
        shouldDeselect: Bool,
        onSelect: PizzaEmptyClosure?
    ) {
        self.id = id
        self.iconName = iconName
        self.iconBackgroundColor = iconBackgroundColor
        self.title = title
        self.shouldDeselect = shouldDeselect
        self.onSelect = onSelect
    }

    public func createRenderTarget() -> SimpleListView {
        SimpleListView()
    }

    public func render(in renderTarget: SimpleListView, renderType: RenderType) {
        renderTarget.configure(
            title: title
        )
        renderTarget.iconView.configure(
            icon: .init(
                iconSystemName: iconName,
                iconColor: .white,
                iconFontSize: 16
            ),
            background: .init(
                iconSystemName: "app.fill",
                iconColor: iconBackgroundColor,
                iconFontSize: 32
            )
        )
    }

    public static var separatorInsets: UIEdgeInsets {
        .init(top: 0, left: 44, bottom: 0, right: 0)
    }
    
}

public class SimpleListView: PizzaView {

    public let iconView = SettingsIconView()
    private let titleLabel = UILabel()

    public override func commonInit() {
        super.commonInit()

        iconView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(29)
            }
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalTo(iconView.snp.trailing).offset(16)
                make.top.bottom.equalToSuperview().inset(12)
                make.trailing.equalToSuperview()
            }
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    }

    public func configure(
        title: String?
    ) {
        titleLabel.text = title
    }

}

public class SettingsIconView: PizzaView {

    public struct IconStyle {
        public let iconSystemName: String
        public let iconColor: UIColor
        public let iconFontSize: CGFloat

        public init(iconSystemName: String, iconColor: UIColor, iconFontSize: CGFloat) {
            self.iconSystemName = iconSystemName
            self.iconColor = iconColor
            self.iconFontSize = iconFontSize
        }
    }

    private let backgroundImageView = UIImageView()
    private let foregroundImageView = UIImageView()

    public override func commonInit() {
        super.commonInit()

        backgroundImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            $0.contentMode = .center
        }

        foregroundImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            $0.contentMode = .center
        }
    }

    public func configure(
        icon: IconStyle?,
        background: IconStyle
    ) {
        if let icon {
            foregroundImageView.image = UIImage(
                systemName: icon.iconSystemName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: icon.iconFontSize)
            )
            foregroundImageView.tintColor = icon.iconColor
        }
        foregroundImageView.isHidden = icon == nil

        backgroundImageView.image = UIImage(
            systemName: background.iconSystemName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: background.iconFontSize)
        )
        backgroundImageView.tintColor = background.iconColor


    }

}
