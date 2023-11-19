import SwiftUI
import PizzaCore

public struct PizzaSUIText: View {

    // MARK: - Properties

    public let text: String?
    public let style: UILabelStyle

    // MARK: - Initialization

    public init(text: String?, style: UILabelStyle) {
        self.text = text
        self.style = style
    }

    // MARK: - View

    public var body: some View {
        Text(
            AttributedString(
                StringBuilder(
                    text: text,
                    style: style
                ).build() ?? NSAttributedString()
            )
        ).multilineTextAlignment({
            if
                let paragraphStyle = style.getAttributes()[.paragraphStyle] as? NSParagraphStyle
            {
                switch paragraphStyle.alignment {
                case .left:
                    return .leading
                case .center:
                    return .center
                case .right:
                    return .trailing
                default:
                    break
                }
            }
            return .leading
        }())
    }

}
