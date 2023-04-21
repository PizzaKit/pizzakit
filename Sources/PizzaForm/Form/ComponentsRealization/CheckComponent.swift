import UIKit
import SnapKit
import PizzaCore
import PizzaDesign

public struct CheckComponent: IdentifiableComponent, ComponentWithAccessories, SelectableComponent {

    public let id: String
    public let title: String
    public let needCheck: Bool

    public let onSelect: PizzaEmptyClosure?
    public var shouldDeselect: Bool { return true }

    public var accessories: [ComponentAccessoryType] {
        return needCheck ? [.check] : []
    }

    public init(
        id: String,
        title: String,
        needCheck: Bool,
        onSelect: PizzaEmptyClosure?
    ) {
        self.id = id
        self.title = title
        self.needCheck = needCheck
        self.onSelect = onSelect
    }

    public func render(in renderTarget: CheckView, renderType: RenderType) {
        renderTarget.configure(title: title)
    }

    public func createRenderTarget() -> CheckView {
        return CheckView()
    }

}

public class CheckView: PizzaView {

    private let titleLabel = UILabel()

    public override func commonInit() {
        super.commonInit()

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.bottom.equalToSuperview().inset(10)
            }
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .left
            $0.textColor = .label
            $0.numberOfLines = 0
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }

}
