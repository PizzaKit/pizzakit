import UIKit
import PizzaKit
import SnapKit

public struct LoadingComponent: IdentifiableComponent {

    public let id: String

    public init(id: String) {
        self.id = id
    }

    public func createRenderTarget() -> LoadingComponentView {
        return LoadingComponentView()
    }

    public func render(in renderTarget: LoadingComponentView, renderType: RenderType) {
        renderTarget.configure()
    }

}

public class LoadingComponentView: PizzaView {

    private let spinnerView = UIActivityIndicatorView(style: .medium)

    public override func commonInit() {
        super.commonInit()

        addSubview(spinnerView)
        spinnerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(14)
        }
        spinnerView.hidesWhenStopped = false
    }

    func configure() {
        let tableViewCell: UITableViewCell? = self.traverseAndFindClass()
        tableViewCell?.backgroundColor = .clear
        spinnerView.startAnimating()
    }

}
