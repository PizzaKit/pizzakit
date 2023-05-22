import SFSafeSymbols
import UIKit
import PizzaKit
import PizzaComponents

class PopupPresenter: ComponentPresenter {

    private enum Constants {
        static let title = "Popup title"
        static let description = "Long description of popup, where you could write anything"
    }

    var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Popups"
        }

        delegate?.render(
            sections: [
                .init(
                    id: "section_popups",
                    cells: [
                        ListComponent(
                            id: "popup_1",
                            title: "Full (buttons horizontal)",
                            selectableContext: .init(
                                shouldDeselect: true,
                                onSelect: { [weak self] in
                                    self?.openFullPopupButtonHorizontal()
                                }
                            ),
                            trailingContent: .arrow
                        ),
                        ListComponent(
                            id: "popup_2",
                            title: "Full (buttons vertical)",
                            selectableContext: .init(
                                shouldDeselect: true,
                                onSelect: { [weak self] in
                                    self?.openFullPopupButtonVertical()
                                }
                            ),
                            trailingContent: .arrow
                        ),
                        ListComponent(
                            id: "popup_3",
                            title: "Full (not closable)",
                            selectableContext: .init(
                                shouldDeselect: true,
                                onSelect: { [weak self] in
                                    self?.openFullPopupNonClosable()
                                }
                            ),
                            trailingContent: .arrow
                        )
                    ]
                )
            ]
        )
    }

    private func openFullPopupButtonVertical() {
        PizzaCardPopup.display(
            info: .init(
                image: .image(
                    UIImage(
                        systemSymbol: .exclamationmarkCircle,
                        withConfiguration: UIImage.SymbolConfiguration(
                            hierarchicalColor: .tintColor
                        )
                    )
                ),
                title: Constants.title,
                description: Constants.description,
                buttons: [
                    .init(
                        title: "Ok",
                        type: .primary,
                        action: {
                            PizzaCardPopup.dismiss()
                        }
                    ),
                    .init(
                        title: "Cancel",
                        type: .secondary,
                        action: {
                            PizzaCardPopup.dismiss()
                        }
                    )
                ]
            ),
            style: .default(
                closable: true,
                buttonAxis: .vertical
            )
        )
    }

    private func openFullPopupButtonHorizontal() {
        PizzaCardPopup.display(
            info: .init(
                image: .image(
                    UIImage(
                        systemSymbol: .trashCircle,
                        withConfiguration: UIImage.SymbolConfiguration(
                            hierarchicalColor: .tintColor
                        )
                    )
                ),
                title: Constants.title,
                description: Constants.description,
                buttons: [
                    .init(
                        title: "Cancel",
                        type: .secondary,
                        action: {
                            PizzaCardPopup.dismiss()
                        }
                    ),
                    .init(
                        title: "Ok",
                        type: .primary,
                        action: {
                            PizzaCardPopup.dismiss()
                        }
                    )
                ]
            ),
            style: .default(
                closable: true,
                buttonAxis: .horizontal
            )
        )
    }

    private func openFullPopupNonClosable() {
        PizzaCardPopup.display(
            info: .init(
                image: .image(
                    UIImage(
                        systemSymbol: .bookmarkCircle,
                        withConfiguration: UIImage.SymbolConfiguration(
                            hierarchicalColor: .tintColor
                        )
                    )
                ),
                title: Constants.title,
                description: Constants.description,
                buttons: [
                    .init(
                        title: "Ok",
                        type: .primary,
                        action: {
                            PizzaCardPopup.dismiss()
                        }
                    ),
                    .init(
                        title: "Cancel",
                        type: .secondary,
                        action: {
                            PizzaCardPopup.dismiss()
                        }
                    )
                ]
            ),
            style: .default(
                closable: false,
                buttonAxis: .vertical
            )
        )
    }

}
