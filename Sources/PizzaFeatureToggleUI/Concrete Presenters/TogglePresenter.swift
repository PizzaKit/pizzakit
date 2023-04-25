import PizzaKit
import Foundation
import Combine
import UIKit

class TogglePresenter: ComponentPresenter {

    weak var delegate: ComponentPresenterDelegate?
    private let featureToggleService: PizzaFeatureToggleService
    private weak var coordinator: PizzaFeatureToggleUICoordinatable?
    private let featureToggle: PizzaAnyFeatureToggle
    private var bag = Set<AnyCancellable>()

    init(
        featureToggleService: PizzaFeatureToggleService,
        coordinator: PizzaFeatureToggleUICoordinatable,
        featureToggle: PizzaAnyFeatureToggle
    ) {
        self.featureToggleService = featureToggleService
        self.coordinator = coordinator
        self.featureToggle = featureToggle
    }

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.title = featureToggle.key
            $0.navigationItem.largeTitleDisplayMode = .never
        }
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
        var cells: [any IdentifiableComponent] = []

        let anyValue = featureToggleService
            .getAnyValue(anyFeatureToggle: featureToggle)

        let override = getCurrentOverride()
        cells.append(
            SwitchComponent(
                id: "switch",
                text: "Turn on override",
                value: anyValue.responseType == .fromOverride,
                isEnabled: true,
                onChanged: { [weak self] isOn in
                    self?.changeOverride(isOn: isOn)
                }
            )
        )
        cells.append(
            ListComponent(
                id: "override_value",
                title: "Override value",
                value: override.value.description,
                titleStyle: anyValue.responseType == .fromOverride
                    ? .allStyles.bodyTint(alignment: .left)
                    : .allStyles.bodyLabel(alignment: .left),
                selectableContext: .init(
                    shouldDeselect: true,
                    onSelect: { [weak self] in
                        guard let self else { return }
                        self.coordinator?.edit(
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
            ListComponent(
                id: "remote_config_value",
                title: "Remote config value",
                value: remoteConfigValue?.anyValue.description,
                titleStyle: anyValue.responseType == .fromRemoteConfig
                    ? .allStyles.bodyTint(alignment: .left)
                    : .allStyles.bodyLabel(alignment: .left)
            )
        )
        cells.append(
            ListComponent(
                id: "default_value",
                title: "Default value",
                value: featureToggle.defaultAnyValue.description,
                titleStyle: anyValue.responseType == .default
                    ? .allStyles.bodyTint(alignment: .left)
                    : .allStyles.bodyLabel(alignment: .left)
            )
        )

        delegate?.render(sections: [
            ComponentSection(
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
