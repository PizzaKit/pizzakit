import SFSafeSymbols
import UIKit
import PizzaKit
import PizzaComponents
import XCoordinator

class MenuPresenter: ComponentPresenter {

    private let router: WeakRouter<PizzaDesignSystemUIRoute>
    var delegate: ComponentPresenterDelegate?

    init(router: WeakRouter<PizzaDesignSystemUIRoute>) {
        self.router = router
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
                                self?.router.trigger(.openComponents)
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
                                self?.router.trigger(.openLabelStyles)
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
                                self?.router.trigger(.openColors)
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
                                self?.router.trigger(.openButtons)
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
                                self?.router.trigger(.openPopups)
                            }
                        ),
                        trailingContent: .arrow
                    )
                ]
            )
        ])
    }

}
