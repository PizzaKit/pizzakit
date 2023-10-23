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
                        icon: .init(sfSymbol: .cube)
                            .apply(preset: .listColoredBGWhiteFG, color: .systemBlue),
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
                        icon: .init(sfSymbol: .characterCursorIbeam)
                            .apply(preset: .listColoredBGWhiteFG, color: .systemGreen),
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
                        icon: .init(sfSymbol: .paintbrush)
                            .apply(preset: .listColoredBGWhiteFG, color: .systemOrange),
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
                        icon: .init(sfSymbol: .rectangleCompressVertical)
                            .apply(preset: .listColoredBGWhiteFG, color: .systemRed),
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
                        icon: .init(sfSymbol: .rectangleBottomthirdInsetFilled)
                            .apply(preset: .listColoredBGWhiteFG, color: .systemTeal),
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
