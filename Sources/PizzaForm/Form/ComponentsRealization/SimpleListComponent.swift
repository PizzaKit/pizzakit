import UIKit
import PizzaKit

public struct SimpleListComponent: IdentifiableComponent {

    public let id: String

    public let iconName: String
    public let iconBackgroundColor: UIColor
    public let title: String?

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
    
}

public class SimpleListView: PizzaView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    public override func commonInit() {
        super.commonInit()

        iconImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalTo(layoutMarginsGuide.snp.leading)
                make.centerY.equalToSuperview()
            }
            $0.contentMode = .center
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(6)
                make.top.bottom.equalToSuperview().inset(12)
                make.trailing.equalTo(layoutMarginsGuide.snp.trailing)
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
