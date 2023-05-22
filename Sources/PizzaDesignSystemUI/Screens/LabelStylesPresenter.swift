import SFSafeSymbols
import UIKit
import PizzaKit

class LabelStylesPresenter: ComponentPresenter {

    var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Label styles"
        }

        delegate?.render(sections: [
            .init(
                id: "section_body",
                header: TitleComponent(
                    id: "body_header",
                    text: "Body",
                    insets: .defaultHeader
                ),
                cells: [
                    ListComponent(
                        id: "style_body_1",
                        title: "Body label",
                        titleStyle: .allStyles.body(color: .palette.label, alignment: .left)
                    )// TODO: realize
                ]
            )
        ])
    }

}
