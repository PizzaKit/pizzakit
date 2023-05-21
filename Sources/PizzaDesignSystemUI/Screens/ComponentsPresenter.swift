import PizzaKit
import SFSafeSymbols
import UIKit

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
                    cells: [
                        ListComponent(
                            id: "list_1",
                            icon: nil,
                            title: "Just title",
                            value: nil,
                            selectableContext: .init(shouldDeselect: true, onSelect: { }),
                            trailingContent: nil
                        ),
                        ListComponent(
                            id: "list_2",
                            icon: nil,
                            title: "Some title",
                            value: "12",
                            selectableContext: .init(shouldDeselect: false, onSelect: { }),
                            trailingContent: nil
                        ),
                        ListComponent(
                            id: "list_3",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .appBadge,
                                    backgroundColor: .systemBlue
                                )
                            ),
                            title: "Icon and title",
                            value: nil,
                            selectableContext: nil,
                            trailingContent: nil
                        ),
                        ListComponent(
                            id: "list_4",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .folder,
                                    backgroundColor: .systemOrange
                                )
                            ),
                            title: "Icon and title",
                            value: "Some value",
                            selectableContext: nil,
                            trailingContent: nil
                        ),
                        ListComponent(
                            id: "list_5",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .externaldrive,
                                    backgroundColor: .systemCyan
                                )
                            ),
                            title: "Title with arrow",
                            value: nil,
                            selectableContext: nil,
                            trailingContent: .arrow
                        ),
                        ListComponent(
                            id: "list_6",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .book,
                                    backgroundColor: .systemIndigo
                                )
                            ),
                            title: "Title with arrow",
                            value: "And long long value",
                            selectableContext: nil,
                            trailingContent: .arrow
                        ),
                        ListComponent(
                            id: "list_7",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .figureWave,
                                    backgroundColor: .systemRed
                                )
                            ),
                            title: "Title with check",
                            value: nil,
                            selectableContext: nil,
                            trailingContent: .check
                        ),
                        ListComponent(
                            id: "list_8",
                            icon: .systemSquareRounded(
                                .init(
                                    sfSymbol: .shift,
                                    backgroundColor: .systemGray
                                )
                            ),
                            title: "Title",
                            value: "Value with check",
                            selectableContext: nil,
                            trailingContent: .check
                        )
                    ],
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

}
