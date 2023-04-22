import PizzaKit
import Foundation
import Combine
import UIKit

public class FeatureTogglePresenter: ComponentPresenter {

    struct State {}

    public weak var delegate: ComponentPresenterDelegate?
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
                    ? .bodyTint(alignment: .left)
                    : .bodyLabel(alignment: .left),
                selectableContext: .init(
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
            ListComponent(
                id: "remote_config_value",
                title: "Remote config value",
                value: remoteConfigValue?.anyValue.description,
                titleStyle: anyValue.responseType == .fromRemoteConfig
                    ? .bodyTint(alignment: .left)
                    : .bodyLabel(alignment: .left)
            )
        )
        cells.append(
            ListComponent(
                id: "default_value",
                title: "Default value",
                value: featureToggle.defaultAnyValue.description,
                titleStyle: anyValue.responseType == .default
                    ? .bodyTint(alignment: .left)
                    : .bodyLabel(alignment: .left)
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

extension UIStyle where Control == UILabel {
    static func bodyTint(alignment: NSTextAlignment) -> UILabelStyle {
        .init(
            font: .systemFont(ofSize: 17),
            color: .tintColor,
            alignment: alignment
        )
    }
}
