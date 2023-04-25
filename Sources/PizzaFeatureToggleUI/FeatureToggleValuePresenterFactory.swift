import PizzaKit

public class FeatureToggleValuePresenterFactory {

    public struct Pair {
        let toggleValueType: PizzaFeatureToggleValueType.Type
        let presenterType: FeatureToggleValuePresenter.Type
    }

    public static var customFactories: [Pair] = []
    public static let defaultFactories: [Pair] = [
        .init(
            toggleValueType: Bool.self,
            presenterType: ToggleBoolValuePresenter.self
        )
    ]

    public static func producePresenter(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    ) -> FeatureToggleValuePresenter? {
        let allFactories = customFactories + defaultFactories
        let defaultPresenter = allFactories.first {
            $0.toggleValueType == anyFeatureToggle.valueType
        }?.presenterType

        // TODO: handle JSON
//        if anyFeatureToggle.valueType is PizzaFeatureToggleJSONValueType {
//
//        }

        return defaultPresenter?.init(
            anyFeatureToggle: anyFeatureToggle,
            anyFeatureToggleOverrideValue: anyFeatureToggleOverrideValue
        )
    }

}
