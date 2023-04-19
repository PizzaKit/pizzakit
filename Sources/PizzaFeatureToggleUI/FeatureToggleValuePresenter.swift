import PizzaKit
import PizzaFeatureToggle
import UIKit

public protocol FeatureToggleValuePresenter: AnyObject {
    init(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    )
    var onNeedSaveValue: PizzaClosure<PizzaFeatureToggleValueType>? { get set }
    func createController() -> UIViewController
}
