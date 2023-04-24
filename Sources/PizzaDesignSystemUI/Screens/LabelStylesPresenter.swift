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
                        titleStyle: .allStyles.bodyLabel(alignment: .left)
                    ),
                    ListComponent(
                        id: "style_body_2",
                        title: "Body tint",
                        titleStyle: .allStyles.bodyTint(alignment: .left)
                    ),
                    ListComponent(
                        id: "style_body_3",
                        title: "Body secondary label",
                        titleStyle: .allStyles.bodySecondaryLabel(alignment: .left)
                    ),
                    ListComponent(
                        id: "style_body_4",
                        title: "Body label semibold",
                        titleStyle: .allStyles.bodyLabelSemibold(alignment: .left)
                    )
                ]
            ),
            .init(
                id: "section_rubric",
                header: TitleComponent(
                    id: "rubric_header",
                    text: "Rubric",
                    insets: .defaultHeader
                ),
                cells: [
                    ListComponent(
                        id: "style_rubric_1",
                        title: "Rubric 2 label",
                        titleStyle: .allStyles.rubric2Label(alignment: .left)
                    ),
                    ListComponent(
                        id: "style_rubric_2",
                        title: "Rubric 2 secondary label",
                        titleStyle: .allStyles.rubric2SecondaryLabel(alignment: .left)
                    )
                ]
            )
        ])
    }

}
