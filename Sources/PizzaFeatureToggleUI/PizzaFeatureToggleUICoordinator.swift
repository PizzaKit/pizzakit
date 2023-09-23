import PizzaKit
import SPIndicator

public protocol PizzaFeatureToggleUICoordinatable: AnyObject {
    func open(anyFeatureToggle: PizzaAnyFeatureToggle)
    func edit(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    )
}

public class PizzaFeatureToggleUICoordinator<Deeplink>: PizzaRouterCoordinator<Deeplink>, PizzaFeatureToggleUICoordinatable {

    // MARK: - Propeties

    private let featureToggleService: PizzaFeatureToggleService

    // MARK: - Initialization

    public init(featureToggleService: PizzaFeatureToggleService) {
        self.featureToggleService = featureToggleService
        super.init()
    }

    // MARK: - Coordinator

    public override func start() {
        let presenter = TogglesListPresenter(
            featureToggleService: featureToggleService,
            coordinator: self
        )
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    // MARK: - PizzaFeatureToggleUICoordinatable

    public func open(anyFeatureToggle: PizzaAnyFeatureToggle) {
        let presenter = TogglePresenter(
            featureToggleService: featureToggleService,
            coordinator: self,
            featureToggle: anyFeatureToggle
        )
        let controller = ComponentTableController(presenter: presenter)
        router.push(module: controller)
    }

    public func edit(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    ) {
        guard let presenter = FeatureToggleValuePresenterFactory.producePresenter(
            anyFeatureToggle: anyFeatureToggle,
            anyFeatureToggleOverrideValue: anyFeatureToggleOverrideValue
        ) else {
            SPIndicator.present(title: "Unsupported type \(anyFeatureToggle.valueType)", preset: .error)
            return
        }
        presenter.onNeedSaveValue = { [weak self] newValue in
            self?.featureToggleService.setAnyOverride(
                forAnyFeatureToggle: anyFeatureToggle,
                anyOverrideValue: .init(
                    value: newValue,
                    valueType: anyFeatureToggleOverrideValue.valueType,
                    isOverrideEnabled: anyFeatureToggleOverrideValue.isOverrideEnabled
                )
            )
        }
        let controller = presenter.createController()
        router.push(module: controller)
    }

}
