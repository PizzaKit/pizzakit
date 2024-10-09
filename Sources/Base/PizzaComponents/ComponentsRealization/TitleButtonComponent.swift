import UIKit
import PizzaCore
import PizzaDesign
import SnapKit

public struct TitleButtonComponent: IdentifiableComponent {

    public struct Button {
        public let style: UIStyle<UIButton>
        public let onPress: PizzaEmptyClosure?

        public init(style: UIStyle<UIButton>, onPress: PizzaEmptyClosure?) {
            self.style = style
            self.onPress = onPress
        }
    }

    public var id: String
    public let stringBuildable: StringBuildable
    public let button: Button?
    public let insets: NSDirectionalEdgeInsets
    public let layoutType: ComponentLayoutType

    public init(
        id: String,
        stringBuildable: StringBuildable,
        button: Button?,
        insets: NSDirectionalEdgeInsets,
        layoutType: ComponentLayoutType = .layoutMargin
    ) {
        self.id = id
        self.stringBuildable = stringBuildable
        self.button = button
        self.insets = insets
        self.layoutType = layoutType
    }

    public func createRenderTarget() -> TitleButtonComponentView {
        return TitleButtonComponentView()
    }

    public func render(in renderTarget: TitleButtonComponentView, renderType: RenderType) {
        renderTarget.configure(
            stringBuildable: stringBuildable,
            button: button,
            insets: insets
        )
    }

}

public class TitleButtonComponentView: PizzaView {

    private let titleLabel = PizzaLabel()
    private let trailingButton = UIButton()

    private var onPress: PizzaEmptyClosure?

    public override func commonInit() {
        super.commonInit()

        titleLabel.do {
            $0.numberOfLines = 0
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
            }
        }

        trailingButton.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.equalTo(titleLabel.snp.top).offset(-20)
                make.bottom.equalTo(titleLabel.snp.bottom).offset(20)
                make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
            }
            $0.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        }
    }

    @objc
    private func handleButtonPress() {
        onPress?()
    }

    public func configure(
        stringBuildable: StringBuildable,
        button: TitleButtonComponent.Button?,
        insets: NSDirectionalEdgeInsets
    ) {
        titleLabel.attributedText = stringBuildable.build()

        titleLabel.snp.updateConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(insets)
        }
        trailingButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(insets)
        }

        trailingButton.isHidden = button == nil
        onPress = button?.onPress
        button.map { trailingButton.apply(style: $0.style) }
    }

}

