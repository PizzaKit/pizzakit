import PizzaKit

public protocol PizzaFeatureToggleUIRouter {
    func open(anyFeatureToggle: PizzaAnyFeatureToggle)
    func edit(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    )
}
