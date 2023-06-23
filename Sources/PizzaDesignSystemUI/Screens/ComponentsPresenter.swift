import PizzaKit
import SFSafeSymbols
import UIKit
import PizzaComponents

class ComponentsPresenter: ComponentPresenter {

    weak var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Components"
            $0.scrollView.keyboardDismissMode = .onDrag
        }
        delegate?.render(
            sections: [
                // loading
                .init(
                    id: "loading_section_with_background",
                    header: TitleComponent(
                        id: "loading_header_1",
                        text: "Loader with background",
                        insets: .defaultHeader
                    ),
                    cells: [
                        LoadingComponent(
                            id: "loading_with_background",
                            backgroundStyle: .withBackground
                        )
                    ]
                ),
                .init(
                    id: "loading_section_without_background",
                    header: TitleComponent(
                        id: "loading_header_2",
                        text: "Loader without background",
                        insets: .defaultHeader
                    ),
                    cells: [
                        LoadingComponent(
                            id: "loading_without_background",
                            backgroundStyle: .withoutBackground
                        )
                    ]
                ),

                // switch
                .init(
                    id: "switch_section",
                    header: TitleComponent(
                        id: "switch_header",
                        text: "Switch components",
                        insets: .defaultHeader
                    ),
                    cells: [
                        SwitchComponent(
                            id: "switch_1",
                            icon: nil,
                            text: "Switch with haptic",
                            value: true,
                            style: .default,
                            isEnabled: true,
                            onChanged: { _ in }
                        ),
                        SwitchComponent(
                            id: "switch_2",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .paintpalette,
                                    backgroundColor: .systemGreen
                                )
                            ),
                            text: "Disabled switch",
                            value: false,
                            style: .default,
                            isEnabled: false,
                            onChanged: { _ in }
                        ),
                        SwitchComponent(
                            id: "switch_3",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .globe,
                                    backgroundColor: .systemCyan
                                )
                            ),
                            text: "Disabled switch with long description",
                            value: true,
                            style: .default,
                            isEnabled: false,
                            onChanged: { _ in }
                        )
                    ],
                    footer: TitleComponent(
                        id: "switch_footer",
                        text: "Supports icon, title and haptic (you can turn it off)",
                        insets: .defaultFooter
                    )
                ),

                // List
                .init(
                    id: "list",
                    header: TitleComponent(
                        id: "list_header",
                        text: "List components",
                        insets: .defaultHeader
                    ),
                    cells: generateAllListComponents(),
                    footer: TitleComponent(
                        id: "list_footer",
                        text: "Supports icon, title, value, check, arrow in different variations",
                        insets: .defaultFooter
                    )
                ),

                // App component
                .init(
                    id: "app_info_section",
                    header: TitleComponent(
                        id: "app_info_header",
                        text: "App info component",
                        insets: .defaultHeader
                    ),
                    cells: [
                        AppInfoComponent(
                            id: "app_info",
                            appIcon: UIImage(color: .tintColor, size: .init(side: 1000)),
                            appInfo: "AppName\nVersion 1.0.0\nbuild 1",
                            onPressedMultipleTimes: nil
                        )
                    ]
                ),

                // TextField
                .init(
                    id: "text_field_section",
                    header: TitleComponent(
                        id: "text_field_header",
                        text: "Text field",
                        insets: .defaultHeader
                    ),
                    cells: [
                        TextFieldComponent(
                            id: "text_field",
                            text: nil,
                            style: .allStyles.standardTextField(
                                placeholder: "Placeholder"
                            ),
                            onTextChanged: nil,
                            onTextBeginEditing: nil,
                            onTextEndEditing: nil,
                            shouldReturnKey: nil
                        )
                    ],
                    footer: TitleComponent(
                        id: "text_field_footer",
                        text: "You can write in textfield everything you want",
                        insets: .defaultFooter
                    )
                )
            ]
        )
    }

    private func generateAllListComponents() -> [ListComponent] {
        var components: [ListComponent] = []

        let allIcons: [ComponentIcon?] = [
            nil,
            .systemSquareRounded(
                .init(
                    sfSymbol: .paintpalette,
                    tintColor: .white,
                    backgroundColor: .systemRed
                )
            ),
            .systemSquareRounded(
                .init(
                    sfSymbol: .paintpalette,
                    tintColor: .tintColor,
                    backgroundColor: nil
                )
            ),
            .background(color: .systemPurple)
        ]
        var allValues: [String?] = ["Value", nil]
        var allValuePosition: [ListComponent.ValuePosition] = [
            .trailing,
            .bottom
        ]
        var allTrailingContents: [ListComponent.TrailingContent?] = [
            nil,
            .arrow,
            .check,
            .sfSymbol(.lock)
        ]

        for icon in allIcons {
            for value in allValues {
                for position in allValuePosition {
                    if position == .bottom, value == nil {
                        continue
                    }
                    for content in allTrailingContents {
                        components.append(
                            ListComponent(
                                id: UUID().uuidString,
                                icon: icon,
                                title: "Title",
                                value: value,
                                labelsStyle: .defaultOneLine,
                                valuePosition: position,
                                selectableContext: nil,
                                trailingContent: content
                            )
                        )
                    }
                }
            }
        }

        return components
    }

}
