import UIKit
import PizzaCore
import PizzaDesign
import SnapKit

public struct TitleComponent: IdentifiableComponent {

    public var id: String
    public let text: String?
    public let style: UIStyle<PizzaLabel>
    public let insets: NSDirectionalEdgeInsets

    public init(
        id: String,
        text: String?,
        style: UIStyle<PizzaLabel> = .allStyles.footnote(color: .palette.labelSecondary, alignment: .left),
        insets: NSDirectionalEdgeInsets
    ) {
        self.id = id
        self.text = text
        self.style = style
        self.insets = insets
    }

    public func createRenderTarget() -> TitleComponentView {
        return TitleComponentView()
    }

    public func render(in renderTarget: TitleComponentView, renderType: RenderType) {
        renderTarget.configure(
            text: text,
            style: style,
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
        text: String?,
        style: UIStyle<PizzaLabel>,
        insets: NSDirectionalEdgeInsets
    ) {
        titleLabel.text = text
        titleLabel.style = style

        titleLabel.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
    }

}

