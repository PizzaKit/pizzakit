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
                        titleStyle: .allStyles.body(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "color_text_2",
                        icon: .background(color: .palette.labelSecondary),
                        title: "Label secondary",
                        titleStyle: .allStyles.body(
                            color: .palette.labelSecondary,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "color_text_3",
                        icon: .background(color: .palette.labelTertiary),
                        title: "Label tertiary",
                        titleStyle: .allStyles.body(
                            color: .palette.labelTertiary,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "color_text_4",
                        icon: .background(color: .palette.labelError),
                        title: "Label error",
                        titleStyle: .allStyles.body(
                            color: .palette.labelError,
                            alignment: .left
                        )
                    )
                ]
            )
        ])
    }

}
