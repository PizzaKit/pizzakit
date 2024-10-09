import SFSafeSymbols
import UIKit
import PizzaKit
import PizzaComponents

class ColorsPresenter: ComponentPresenter {

    var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Colors"
        }

        delegate?.render(
            sections: [
                .init(
                    id: "bg_colors",
                    header: TitleComponent(
                        id: "bg_header",
                        text: "Background",
                        insets: .defaultHeader
                    ),
                    cells: [
                        ListComponent(
                            id: "color_bg",
                            icon: .init()
                                .apply(
                                    preset: .listColoredBGWhiteFG,
                                    color: .palette.background
                                ),
                            title: "Background",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.label,
                                    alignment: .left
                                )
                            )
                        ),
                        ListComponent(
                            id: "color_bg_sec",
                            icon: .init()
                                .apply(
                                    preset: .listColoredBGWhiteFG,
                                    color: .palette.backgroundSecondary
                                ),
                            title: "Background secondaty",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.label,
                                    alignment: .left
                                )
                            )
                        ),
                        ListComponent(
                            id: "color_bg_ter",
                            icon: .init()
                                .apply(
                                    preset: .listColoredBGWhiteFG,
                                    color: .palette.backgroundTertiary
                                ),
                            title: "Background tertiary",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.label,
                                    alignment: .left
                                )
                            )
                        )
                    ]
                ),
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
                            icon: .init()
                                .apply(preset: .listColoredBGWhiteFG, color: .palette.label),
                            title: "Label",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.label,
                                    alignment: .left
                                )
                            )
                        ),
                        ListComponent(
                            id: "color_text_2",
                            icon: .init()
                                .apply(preset: .listColoredBGWhiteFG, color: .palette.labelSecondary),
                            title: "Label secondary",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.labelSecondary,
                                    alignment: .left
                                )
                            )
                        ),
                        ListComponent(
                            id: "color_text_3",
                            icon: .init()
                                .apply(preset: .listColoredBGWhiteFG, color: .palette.labelTertiary),
                            title: "Label tertiary",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.labelTertiary,
                                    alignment: .left
                                )
                            )
                        ),
                        ListComponent(
                            id: "color_text_4",
                            icon: .init()
                                .apply(preset: .listColoredBGWhiteFG, color: .palette.labelError),
                            title: "Label error",
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: .palette.labelError,
                                    alignment: .left
                                )
                            )
                        )
                    ]
                ),
                .init(
                    id: "tint_colors",
                    header: TitleComponent(
                        id: "tint_colors",
                        text: "Tint colors",
                        insets: .defaultHeader
                    ),
                    cells: PizzaAppTheme.allTintColors.enumerated().map {
                        var title = "Hex: \($0.element.hex)"
                        if $0.offset == PizzaAppTheme.defaultTintColorIndex {
                            title += " (default)"
                        }
                        return ListComponent(
                            id: "tint_color_\($0.offset)",
                            icon: .init()
                                .apply(preset: .listColoredBGWhiteFG, color: $0.element),
                            title: title,
                            labelsStyle: .init(
                                titleStyle: .allStyles.body(
                                    color: $0.element,
                                    alignment: .left
                                )
                            )
                        )
                    }
                )
            ]
        )
    }

}
