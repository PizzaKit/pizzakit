import UIKit
import PizzaCore
import SnapKit

public struct TitleComponent: IdentifiableComponent {

    public struct Style {
        public init(font: UIFont, insets: NSDirectionalEdgeInsets, textColor: UIColor, textAlignment: NSTextAlignment) {
            self.font = font
            self.insets = insets
            self.textColor = textColor
            self.textAlignment = textAlignment
        }

        public let font: UIFont
        public let insets: NSDirectionalEdgeInsets
        public let textColor: UIColor
        public let textAlignment: NSTextAlignment
    }

    public var id: String
    public let text: String?
    public let style: Style

    public init(id: String, text: String? = nil, style: Style) {
        self.id = id
        self.text = text
        self.style = style
    }

    public func createRenderTarget() -> UILabel {
        return UILabel()
    }

    public func layout(renderTarget: UILabel, in container: UIView) {
        renderTarget.do {
            container.addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading
                    .equalTo(container.layoutMarginsGuide.snp.leading)
                    .inset(style.insets.leading)
                make.top
                    .equalToSuperview()
                    .inset(style.insets.top)
                make
                    .trailing
                    .equalTo(container.layoutMarginsGuide.snp.trailing)
                    .inset(style.insets.trailing)
                    .priority(999)
                make
                    .bottom
                    .equalToSuperview()
                    .inset(style.insets.bottom)
                    .priority(999)
            }
        }
    }

    public func render(in renderTarget: UILabel, renderType: RenderType) {
        renderTarget.font = style.font
        renderTarget.textAlignment = style.textAlignment
        renderTarget.textColor = style.textColor
        renderTarget.text = text
        renderTarget.numberOfLines = 0
    }

}
