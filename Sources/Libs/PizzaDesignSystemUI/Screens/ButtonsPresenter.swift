import SFSafeSymbols
import UIKit
import PizzaKit
import PizzaComponents

class ButtonsPresenter: ComponentPresenter {

    var delegate: ComponentPresenterDelegate?

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.largeTitleDisplayMode = .never
            $0.navigationItem.title = "Button styles"
        }

        let enabledArray = [true, false]
        let isLoadingArray = [true, false]
        let sizesArray: [PizzaButtonStylesSize] = [.large, .medium, .small]
        let typeArray: [PizzaButtonStylesType] = [.primary, .secondary, .tertiary, .error, .errorTertiary]

        var counter = 0
        var components: [any IdentifiableComponent] = []

        for sizeItem in sizesArray {
            for typeItem in typeArray {
                for enabledItem in enabledArray {
                    for isLoadingItem in isLoadingArray {

                        let title = {
                            let sizeString = {
                                switch sizeItem {
                                case .large:
                                    return "L"
                                case .medium:
                                    return "M"
                                case .small:
                                    return "S"
                                case .custom:
                                    return "C"
                                }
                            }()
                            let typeString = {
                                switch typeItem {
                                case .primary:
                                    return "primary"
                                case .secondary:
                                    return "secondary"
                                case .tertiary:
                                    return "tertiary"
                                case .error:
                                    return "errror"
                                case .errorTertiary:
                                    return "errTertiary"
                                }
                            }()
                            let enabledString: String? = {
                                if enabledItem {
                                    return nil
                                }
                                return "disabled"
                            }()
                            let loadingString: String? = {
                                if isLoadingItem {
                                    return "loading"
                                }
                                return nil
                            }()

                            return [
                                sizeString,
                                typeString,
                                enabledString,
                                loadingString
                            ].compactMap { $0 }.joined(separator: ", ")
                        }()
                        components.append(
                            PizzaButtonComponent(
                                id: "button_\(counter)",
                                buttonStyle: {
                                    if isLoadingItem {
                                        return .allStyles.loading(
                                            title: title,
                                            size: sizeItem,
                                            type: typeItem
                                        )
                                    }
                                    return .allStyles.standard(
                                        title: title,
                                        size: sizeItem,
                                        type: typeItem
                                    )
                                }(),
                                onPress: nil,
                                isEnabled: enabledItem
                            )
                        )

                        counter += 1
                    }
                }
            }
        }

        delegate?.render(sections: [
            .init(
                id: "section",
                cells: components
            )
        ])
    }

}
