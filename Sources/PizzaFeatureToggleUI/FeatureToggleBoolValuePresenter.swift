import PizzaKit
import UIKit

public class FeatureToggleBoolValuePresenter: FeatureToggleValuePresenter, ComponentPresenter {

    struct State {
        var value: Bool
    }

    public weak var delegate: ComponentPresenterDelegate?

    public var onNeedSaveValue: PizzaClosure<PizzaFeatureToggleValueType>?

    private var state: State {
        didSet {
            onNeedSaveValue?(state.value)
            render()
        }
    }

    public required init(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    ) {
        state = .init(
            value: (anyFeatureToggleOverrideValue.value as? Bool) ?? false
        )
    }

    public func createController() -> UIViewController {
        ComponentTableController(presenter: self)
    }

    public func touch() {
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
