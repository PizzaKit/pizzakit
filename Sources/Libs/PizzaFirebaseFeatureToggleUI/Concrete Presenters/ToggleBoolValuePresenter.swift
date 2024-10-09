import PizzaKit
import UIKit

class ToggleBoolValuePresenter: FeatureToggleValuePresenter, ComponentPresenter {

    struct State {
        var value: Bool
    }

    weak var delegate: ComponentPresenterDelegate?

    var onNeedSaveValue: PizzaClosure<PizzaFeatureToggleValueType>?

    private var state: State {
        didSet {
            onNeedSaveValue?(state.value)
            render()
        }
    }

    required init(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    ) {
        state = .init(
            value: (anyFeatureToggleOverrideValue.value as? Bool) ?? false
        )
    }

    func createController() -> UIViewController {
        ComponentTableController(presenter: self)
    }

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.title = "Edit overrided value"
        }
        render()
    }

    private func render() {
        delegate?.render(sections: [
            ComponentSection(
                id: "section",
                cells: [
                    SwitchComponent(
                        id: "switch_component",
                        text: "Value",
                        value: state.value,
                        isEnabled: true,
                        onChanged: { [weak self] isOn in
                            self?.state.value = isOn
                        }
                    )
                ]
            )
        ])
    }

}
