import PizzaKit
import Foundation
import Combine

public class FeatureTogglePresenter: FormPresenter {

    struct State {}

    public weak var delegate: FormPresenterDelegate?
    private let featureToggleService: PizzaFeatureToggleService
    private let router: PizzaFeatureToggleUIRouter
    private let featureToggle: PizzaAnyFeatureToggle
    private var state: State = .init() {
        didSet { render() }
    }
    private var bag = Set<AnyCancellable>()

    public init(
        featureToggleService: PizzaFeatureToggleService,
        router: PizzaFeatureToggleUIRouter,
        featureToggle: PizzaAnyFeatureToggle
    ) {
        self.featureToggleService = featureToggleService
        self.router = router
        self.featureToggle = featureToggle
    }

    public func touch() {
        featureToggleService
            .reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.render()
            }
            .store(in: &bag)

        render()
    }

    private func render() {
        var cells: [CellNode] = []

        let anyValue = featureToggleService
            .getAnyValue(anyFeatureToggle: featureToggle)

        let override = getCurrentOverride()
        cells.append(
            .init(
                component: SwitchComponent(
                    id: "switch",
                    text: "Turn on override",
                    value: anyValue.responseType == .fromOverride,
                    isEnabled: true,
                    onChanged: { [weak self] isOn in
                        self?.changeOverride(isOn: isOn)
                    }
                )
            )
        )
        cells.append(
            .init(
                component: TitleValueSelectableComponent(
                    id: "override_value",
                    title: "Override value",
                    description: override.value.description,
                    style: anyValue.responseType == .fromOverride
                        ? .accentArrow
                        : .defaultArrow,
                    shouldDeselect: true,
                    onSelect: { [weak self] in
                        guard let self else { return }
                        self.router.edit(
                            anyFeatureToggle: self.featureToggle,
                            anyFeatureToggleOverrideValue: self.getCurrentOverride()
                        )
                    }
                )
            )
        )

        let remoteConfigValue = featureToggleService.getAnyValue(
            anyFeatureToggle: featureToggle,
            responseType: .fromRemoteConfig
        )
        cells.append(
            .init(
                component: TitleValueComponent(
                    id: "remote_config_value",
                    title: "Remote config value",
                    description: remoteConfigValue?.anyValue.description ?? "<none>",
                    style: anyValue.responseType == .fromRemoteConfig ? .accent : .default
                )
            )
        )
        cells.append(
            .init(
                component: TitleValueComponent(
                    id: "default_value",
                    title: "Default value",
                    description: featureToggle.defaultAnyValue.description,
                    style: anyValue.responseType == .default
                        ? .accent
                        : .default
                )
            )
        )

        delegate?.render(sections: [
            Section(
                id: "override_section",
                cells: cells
            )
        ])
    }

    private func updateItem() {

    }

    private func changeOverride(
        isOn: Bool
    ) {
        let currentOverrider = getCurrentOverride()
        let newOverride = PizzaAnyFeatureToggleOverrideValue(
            value: currentOverrider.value,
            valueType: currentOverrider.valueType,
            isOverrideEnabled: isOn
        )
        featureToggleService.setAnyOverride(
            forAnyFeatureToggle: featureToggle,
            anyOverrideValue: newOverride
        )

        render()
    }

    private func getCurrentOverride() -> PizzaAnyFeatureToggleOverrideValue {
        featureToggleService.getAnyOverride(
            forAnyFeatureToggle: featureToggle
        ) ?? PizzaAnyFeatureToggleOverrideValue(
            value: featureToggle.defaultAnyValue,
            valueType: featureToggle.valueType,
            isOverrideEnabled: false
        )
    }

}

extension TitleValueComponent.Style {
    public static let accent = TitleValueComponent.Style(
        titleColor: .tintColor,
        valueColor: .secondaryLabel,
        needArrow: false,
        numberOfLines: 1
    )
    public static let accentArrow = TitleValueComponent.Style(
        titleColor: .tintColor,
        valueColor: .secondaryLabel,
        needArrow: true,
        numberOfLines: 1
    )
}
