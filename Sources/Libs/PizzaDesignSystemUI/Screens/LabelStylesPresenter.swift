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
                        labelsStyle: .init(
                            titleStyle: .allStyles.largeTitle(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_title_1",
                        title: "Title 1",
                        labelsStyle: .init(
                            titleStyle: .allStyles.title1(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_title_2",
                        title: "Title 2",
                        labelsStyle: .init(
                            titleStyle: .allStyles.title2(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_title_3",
                        title: "Title 3",
                        labelsStyle: .init(
                            titleStyle: .allStyles.title3(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_headline",
                        title: "Headline",
                        labelsStyle: .init(
                            titleStyle: .allStyles.headline(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_body",
                        title: "Body",
                        labelsStyle: .init(
                            titleStyle: .allStyles.body(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_callout",
                        title: "Callout",
                        labelsStyle: .init(
                            titleStyle: .allStyles.callout(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_subhead",
                        title: "Subhead",
                        labelsStyle: .init(
                            titleStyle: .allStyles.subhead(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_footnote",
                        title: "Footnote",
                        labelsStyle: .init(
                            titleStyle: .allStyles.footnote(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_footnote_semibold",
                        title: "Footnote Semibold",
                        labelsStyle: .init(
                            titleStyle: .allStyles.footnoteSemibold(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_caption_1",
                        title: "Caption 1",
                        labelsStyle: .init(
                            titleStyle: .allStyles.caption1(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    ),
                    ListComponent(
                        id: "style_caption_2",
                        title: "Caption 2",
                        labelsStyle: .init(
                            titleStyle: .allStyles.caption2(
                                color: .palette.label,
                                alignment: .left
                            )
                        )
                    )
                ]
            )
        ])
    }

}
