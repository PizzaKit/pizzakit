import UIKit
import PizzaDesign
import SnapKit

public struct LoadingComponent: IdentifiableComponent {

    public enum BackgroundStyle {
        case withBackground
        case withoutBackground
    }

    public let id: String
    public let backgroundStyle: BackgroundStyle

    public init(
        id: String,
        backgroundStyle: BackgroundStyle = .withoutBackground
    ) {
        self.id = id
        self.backgroundStyle = backgroundStyle
    }

    public func createRenderTarget() -> LoadingComponentView {
        return LoadingComponentView()
    }

    public func render(in renderTarget: LoadingComponentView, renderType: RenderType) {
        renderTarget.configure(backgroundStyle: backgroundStyle)
    }

}

public class LoadingComponentView: PizzaView {

    private let spinnerView = UIActivityIndicatorView(style: .medium)
    private var savedColor: UIColor?

    public override func commonInit() {
        super.commonInit()

        addSubview(spinnerView)
        spinnerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(14)
        }
        spinnerView.hidesWhenStopped = false
    }

    func configure(backgroundStyle: LoadingComponent.BackgroundStyle) {
        switch backgroundStyle {
        case .withoutBackground:
            let tableViewCell: UITableViewCell? = self.traverseAndFindClass()
            savedColor = tableViewCell?.backgroundColor
            tableViewCell?.backgroundColor = .clear
        case .withBackground:
            if let savedColor {
                let tableViewCell: UITableViewCell? = self.traverseAndFindClass()
                tableViewCell?.backgroundColor = savedColor
            }
        }

        spinnerView.startAnimating()
    }

}
