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
                id: "section",
                cells: [
                    ListComponent(
                        id: "style_large_title",
                        title: "Large title",
                        titleStyle: .allStyles.largeTitle(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_title_1",
                        title: "Title 1",
                        titleStyle: .allStyles.title1(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_title_2",
                        title: "Title 2",
                        titleStyle: .allStyles.title2(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_title_3",
                        title: "Title 3",
                        titleStyle: .allStyles.title3(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_headline",
                        title: "Headline",
                        titleStyle: .allStyles.headline(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_body",
                        title: "Body",
                        titleStyle: .allStyles.body(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_callout",
                        title: "Callout",
                        titleStyle: .allStyles.callout(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_subhead",
                        title: "Subhead",
                        titleStyle: .allStyles.subhead(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_footnote",
                        title: "Footnote",
                        titleStyle: .allStyles.footnote(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_caption_1",
                        title: "Caption 1",
                        titleStyle: .allStyles.caption1(
                            color: .palette.label,
                            alignment: .left
                        )
                    ),
                    ListComponent(
                        id: "style_caption_2",
                        title: "Caption 2",
                        titleStyle: .allStyles.caption2(
                            color: .palette.label,
                            alignment: .left
                        )
                    )
                ]
            )
        ])
    }

}
