import SFSafeSymbols
import UIKit
import PizzaKit
import PizzaComponents

class MenuPresenter: ComponentPresenter {

    private weak var coordinator: PizzaDesignSystemUICoordinatable?
    var delegate: ComponentPresenterDelegate?

    init(coordinator: PizzaDesignSystemUICoordinatable) {
        self.coordinator = coordinator
    }

    deinit {
        coordinator?.moduleWasDeallocated()
    }

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Design system"
        }

        delegate?.render(sections: [
            .init(
                id: "section",
                cells: [
                    ListComponent(
                        id: "components",
                        icon: .systemSquareRounded(
                            .init(
                                sfSymbol: .cube,
                                backgroundColor: .systemBlue
                            )
                        ),
                        title: "Components",
                        selectableContext: .init(
                            shouldDeselect: false,
                            onSelect: { [weak self] in
                                self?.coordinator?.openComponents()
                            }
                        ),
                        trailingContent: .arrow
                    ),
                    ListComponent(
                        id: "label_styles",
                        icon: .systemSquareRounded(
                            .init(
                                sfSymbol: .characterCursorIbeam,
                                backgroundColor: .systemGreen
                            )
                        ),
                        title: "Label styles",
                        selectableContext: .init(
                            shouldDeselect: false,
                            onSelect: { [weak self] in
                                self?.coordinator?.openLabelStyles()
                            }
                        ),
                        trailingContent: .arrow
                    ),
                    ListComponent(
                        id: "colors",
                        icon: .systemSquareRounded(
                            .init(
                                sfSymbol: .paintbrush,
                                backgroundColor: .systemOrange
                            )
                        ),
                        title: "Colors",
                        selectableContext: .init(
                            shouldDeselect: false,
                            onSelect: { [weak self] in
                                self?.coordinator?.openColors()
                            }
                        ),
                        trailingContent: .arrow
                    ),
                    ListComponent(
                        id: "buttons",
                        icon: .systemSquareRounded(
                            .init(
                                sfSymbol: .rectangleCompressVertical,
                                backgroundColor: .systemRed
                            )
                        ),
                        title: "Buttons",
                        selectableContext: .init(
                            shouldDeselect: false,
                            onSelect: { [weak self] in
                                self?.coordinator?.openButtons()
                            }
                        ),
                        trailingContent: .arrow
                    ),
                    ListComponent(
                        id: "popups",
                        icon: .systemSquareRounded(
                            .init(
                                sfSymbol: .rectangleBottomthirdInsetFilled,
                                backgroundColor: .systemTeal
                            )
                        ),
                        title: "Popups",
                        selectableContext: .init(
                            shouldDeselect: false,
                            onSelect: { [weak self] in
                                self?.coordinator?.openPopups()
                            }
                        ),
                        trailingContent: .arrow
                    )
                ]
            )
        ])
    }

}
