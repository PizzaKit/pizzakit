import SFSafeSymbols
import UIKit
import PizzaKit

class ColorsPresenter: ComponentPresenter {

    var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Label styles"
        }

        delegate?.render(sections: [
            .init(
                id: "text_colors",
                header: TitleComponent(
                    id: "text_header",
                    text: "Text",
                    insets: .defaultHeader
                ),
                cells: [
                    ListComponent(
                        id: "color_text_1",
                        icon: .background(color: .palette.label),
                        title: "Label",
                        titleStyle: CustomLabelStyle(
                            color: .palette.label,
                            baseStyle: .allStyles.bodyLabel(alignment: .left)
                        )
                    ),
                    ListComponent(
                        id: "color_text_2",
                        icon: .background(color: .palette.labelSecondary),
                        title: "Label secondary",
                        titleStyle: CustomLabelStyle(
                            color: .palette.labelSecondary,
                            baseStyle: .allStyles.bodyLabel(alignment: .left)
                        )
                    ),
                    ListComponent(
                        id: "color_text_3",
                        icon: .background(color: .palette.labelTertiary),
                        title: "Label tertiary",
                        titleStyle: CustomLabelStyle(
                            color: .palette.labelTertiary,
                            baseStyle: .allStyles.bodyLabel(alignment: .left)
                        )
                    ),
                    ListComponent(
                        id: "color_text_4",
                        icon: .background(color: .palette.labelError),
                        title: "Label error",
                        titleStyle: CustomLabelStyle(
                            color: .palette.labelError,
                            baseStyle: .allStyles.bodyLabel(alignment: .left)
                        )
                    )
                ]
            ),
            .init(
                id: "background_colors",
                header: TitleComponent(
                    id: "background_header",
                    text: "Background",
                    insets: .defaultHeader
                ),
                cells: [
                    ListComponent(
                        id: "color_background_1",
                        icon: .background(color: .palette.background),
                        title: "Background"
                    ),
                    ListComponent(
                        id: "color_background_2",
                        icon: .background(color: .palette.backgroundSecondary),
                        title: "Background secondary"
                    )
                ]
            )
        ])
    }

}

fileprivate class CustomLabelStyle: UIStyle<PizzaLabel> {

    let color: UIColor
    let baseStyle: UIStyle<PizzaLabel>

    init(
        color: UIColor,
        baseStyle: UIStyle<PizzaLabel>
    ) {
        self.color = color
        self.baseStyle = baseStyle
    }

    override func apply(for label: PizzaLabel) {
        baseStyle.apply(for: label)
        if let attributedString = label.attributedText {
            var attributes = attributedString.attributes(at: 0, effectiveRange: nil)
            attributes[.foregroundColor] = color
            label.attributedText = NSAttributedString(
                string: attributedString.string,
                attributes: attributes
            )
        }
    }

}
