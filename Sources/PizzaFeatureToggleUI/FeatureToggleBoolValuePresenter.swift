import PizzaKit
import PizzaFeatureToggle
import PizzaForm
import UIKit

public class FeatureToggleBoolValuePresenter: FeatureToggleValuePresenter, FormPresenter {

    struct State {
        var value: Bool
    }

    public weak var delegate: FormPresenterDelegate?

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
        FormTableController(
            presenter: self,
            onViewDidLoad: {
                $0.navigationItem.title = "Edit overrided value"
            }
        )
    }

    public func touch() {
        render()
    }

    private func render() {
        delegate?.render(sections: [
            Section(
                id: "section",
                cells: [
                    .init(
                        component: SwitchComponent(
                            id: "switch_component",
                            text: "Value",
                            value: state.value,
                            isEnabled: true,
                            onChanged: { [weak self] isOn in
                                self?.state.value = isOn
                            }
                        )
                    )
                ]
            )
        ])
    }

}
