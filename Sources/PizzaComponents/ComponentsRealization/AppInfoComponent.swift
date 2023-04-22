import PizzaDesign
import PizzaCore
import UIKit
import SnapKit

public struct AppInfoComponent: IdentifiableComponent {

    public let id: String
    public let appIcon: UIImage
    public let appInfo: String
    public let onPressedMultipleTimes: PizzaEmptyClosure?

    public init(
        id: String,
        appIcon: UIImage,
        appInfo: String,
        onPressedMultipleTimes: PizzaEmptyClosure?
    ) {
        self.id = id
        self.appIcon = appIcon
        self.appInfo = appInfo
        self.onPressedMultipleTimes = onPressedMultipleTimes
    }

    public func render(in renderTarget: AppInfoComponentView, renderType: RenderType) {
        renderTarget.configure(
            appIcon: appIcon,
            appInfo: appInfo
        )
        renderTarget.onPressedMultipleTimes = onPressedMultipleTimes
    }

    public func createRenderTarget() -> AppInfoComponentView {
        AppInfoComponentView()
    }

}

public class AppInfoComponentView: PizzaView {

    private let appIconImageView = UIImageView()
    private let appInfoLabel = UILabel()

    public var onPressedMultipleTimes: PizzaEmptyClosure?

    public override func commonInit() {
        super.commonInit()

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        tapGestureRecognizer.numberOfTapsRequired = 5
        addGestureRecognizer(tapGestureRecognizer)

        appIconImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.centerX.equalToSuperview()
                make.size.equalTo(128)
            }
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 28
            $0.layer.cornerCurve = .continuous
            $0.layer.masksToBounds = true
        }

        appInfoLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(appIconImageView.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-30)
            }
            UIStyle<UILabel>.bodyLabelSecondary(alignment: .center).apply(for: $0)
            $0.numberOfLines = 0
        }
    }

    public func configure(
        appIcon: UIImage,
        appInfo: String
    ) {
        let tableViewCell: UITableViewCell? = self.traverseAndFindClass()
        tableViewCell?.backgroundColor = .clear

        appIconImageView.image = appIcon
        appInfoLabel.text = appInfo
    }

    @objc
    private func handleTap() {
        onPressedMultipleTimes?()
    }

}
