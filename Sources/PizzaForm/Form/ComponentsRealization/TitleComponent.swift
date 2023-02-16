import UIKit
import PizzaCore
import SnapKit

public struct TitleComponent: Component {

    public struct Style {
        public let font: UIFont
        public let insets: NSDirectionalEdgeInsets
        public let textColor: UIColor
        public let textAlignment: NSTextAlignment
    }

    public let text: String?
    public let style: Style

    init(text: String? = nil, style: Style) {
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
                    .equalToSuperview()
                    .inset(style.insets.leading)
                make.top
                    .equalToSuperview()
                    .inset(style.insets.top)
                make
                    .trailing
                    .equalToSuperview()
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
    }

}
