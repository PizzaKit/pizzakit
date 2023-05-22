import UIKit
import SnapKit
import PizzaKit
import Combine

public struct TitleTimeComponent: IdentifiableComponent, SelectableComponent {

    public let id: String
    public let title: String?
    public let titleStyle: UIStyle<PizzaLabel>
    public let valueStyle: UIStyle<PizzaLabel>
    public let onGetString: PizzaReturnClosure<Date, String>?
    public let onSelect: PizzaEmptyClosure?
    public var shouldDeselect: Bool { true }

    public init(
        id: String,
        title: String?,
        titleStyle: UIStyle<PizzaLabel> = .allStyles.body(color: .palette.label, alignment: .left),
        valueStyle: UIStyle<PizzaLabel> = .allStyles.body(color: .palette.labelSecondary, alignment: .right),
        onGetString: PizzaReturnClosure<Date, String>?,
        onSelect: PizzaEmptyClosure?
    ) {
        self.id = id
        self.title = title
        self.titleStyle = titleStyle
        self.valueStyle = valueStyle
        self.onGetString = onGetString
        self.onSelect = onSelect
    }

    public func render(in renderTarget: TitleTimeComponentView, renderType: RenderType) {
        renderTarget.configure(
            title: title,
            titleStyle: titleStyle,
            valueStyle: valueStyle,
            onGetString: onGetString
        )
    }

    public func createRenderTarget() -> TitleTimeComponentView {
        return TitleTimeComponentView()
    }

}

public class TitleTimeComponentView: PizzaView {

    private let titleLabel = PizzaLabel()
    private let descriptionLabel = PizzaLabel()

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
            $0.numberOfLines = 1
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
            $0.numberOfLines = 1
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
        titleStyle: UIStyle<PizzaLabel>,
        valueStyle: UIStyle<PizzaLabel>,
        onGetString: PizzaReturnClosure<Date, String>?
    ) {
        self.onGetString = onGetString

        titleLabel.style = titleStyle
        descriptionLabel.style = valueStyle

        titleLabel.text = title
        descriptionLabel.text = onGetString?(Date())
    }

}
