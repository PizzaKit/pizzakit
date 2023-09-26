import UIKit
import PizzaCore
import PizzaDesign
import SnapKit

public struct TitleComponent: IdentifiableComponent {

    public var id: String
    public let stringBuildable: StringBuildable
    public let insets: NSDirectionalEdgeInsets
    public let layoutType: ComponentLayoutType

    public init(
        id: String,
        text: String?,
        style: UILabelStyle = .allStyles.footnote(color: .palette.labelSecondary, alignment: .left),
        insets: NSDirectionalEdgeInsets,
        layoutType: ComponentLayoutType = .layoutMargin
    ) {
        self.id = id
        self.stringBuildable = StringBuilder(
            text: text,
            initialAttributes: style.getAttributes()
        )
        self.insets = insets
        self.layoutType = layoutType
    }

    public init(
        id: String,
        stringBuildable: StringBuildable,
        insets: NSDirectionalEdgeInsets,
        layoutType: ComponentLayoutType = .layoutMargin
    ) {
        self.id = id
        self.stringBuildable = stringBuildable
        self.insets = insets
        self.layoutType = layoutType
    }

    public func createRenderTarget() -> TitleComponentView {
        return TitleComponentView()
    }

    public func render(in renderTarget: TitleComponentView, renderType: RenderType) {
        renderTarget.configure(
            stringBuildable: stringBuildable,
            insets: insets
        )
    }

}

public extension NSDirectionalEdgeInsets {
    static var defaultHeader: NSDirectionalEdgeInsets {
        .init(
            top: 20,
            leading: 0,
            bottom: 8,
            trailing: 0
        )
    }
    static var defaultFooter: NSDirectionalEdgeInsets {
        .init(
            top: 8,
            leading: 0,
            bottom: 20,
            trailing: 0
        )
    }
}

public class TitleComponentView: PizzaView {

    private let titleLabel = PizzaLabel()

    public override func commonInit() {
        super.commonInit()

        titleLabel.do {
            $0.numberOfLines = 0
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    public func configure(
        stringBuildable: StringBuildable,
        insets: NSDirectionalEdgeInsets
    ) {
        titleLabel.attributedText = stringBuildable.build()

        titleLabel.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
    }

}

