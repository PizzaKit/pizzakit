import UIKit
import SnapKit
import PizzaKit
import Combine

public struct TitleTimeComponent: IdentifiableComponent, ComponentWithAccessories, SelectableComponent {

    public let id: String
    public let title: String?
    public let onGetString: PizzaReturnClosure<Date, String>?
    public let style: TitleValueComponent.Style
    public let onSelect: PizzaEmptyClosure?
    public var shouldDeselect: Bool { true }

    public var accessories: [ComponentAccessoryType] {
        return style.needArrow ? [.arrow] : []
    }

    public init(
        id: String,
        title: String?,
        onGetString: PizzaReturnClosure<Date, String>?,
        style: TitleValueComponent.Style,
        onSelect: PizzaEmptyClosure?
    ) {
        self.id = id
        self.title = title
        self.onGetString = onGetString
        self.style = style
        self.onSelect = onSelect
    }

    public func render(in renderTarget: TitleTimeComponentView, renderType: RenderType) {
        renderTarget.configure(
            title: title,
            style: style,
            onGetString: onGetString
        )
    }

    public func createRenderTarget() -> TitleTimeComponentView {
        return TitleTimeComponentView()
    }

}

public class TitleTimeComponentView: PizzaView {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private var bag = Set<AnyCancellable>()

    private var onGetString: PizzaReturnClosure<Date, String>?

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
            $0.font = .systemFont(ofSize: 17)
            $0.textAlignment = .right
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44)
        }

        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] currentDate in
                self?.descriptionLabel.text = self?.onGetString?(currentDate)
            }
            .store(in: &bag)
    }

    func configure(
        title: String?,
        style: TitleValueComponent.Style,
        onGetString: PizzaReturnClosure<Date, String>?
    ) {
        self.onGetString = onGetString

        titleLabel.textColor = style.titleColor
        descriptionLabel.textColor = style.valueColor

        titleLabel.numberOfLines = style.numberOfLines
        descriptionLabel.numberOfLines = style.numberOfLines

        titleLabel.text = title
        descriptionLabel.text = onGetString?(Date())
    }

}
