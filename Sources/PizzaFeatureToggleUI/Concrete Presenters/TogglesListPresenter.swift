import PizzaKit
import Foundation
import FirebaseInstallations
import UIKit
import SPIndicator
import Combine
import SFSafeSymbols
import Defaults
import PizzaComponents

class TogglesListPresenter: ComponentPresenter {

    struct State {
        struct FeatureToggle {
            let key: String
            let value: String
            let color: UIColor
            let colorText: String
            let anyFeatureToggle: PizzaAnyFeatureToggle
        }
        var items: [FeatureToggle]
        var preferReferencedTime: Bool
        var installationId: String?
        var isExpanded: Bool
    }

    weak var delegate: ComponentPresenterDelegate?
    private let featureToggleService: PizzaFeatureToggleService
    private weak var coordinator: PizzaFeatureToggleUICoordinatable?
    private var state: State {
        didSet { render() }
    }
    private var bag = Set<AnyCancellable>()

    init(
        featureToggleService: PizzaFeatureToggleService,
        coordinator: PizzaFeatureToggleUICoordinatable
    ) {
        self.featureToggleService = featureToggleService
        self.coordinator = coordinator
        self.state = .init(
            items: [],
            preferReferencedTime: Defaults[.preferReferencedTimeKey],
            isExpanded: Defaults[.isExpanded]
        )

    }

    func touch() {
        delegate?.controller.do {
            $0.navigationItem.title = "Firebase RC"
            $0.navigationItem.largeTitleDisplayMode = .never
        }
        featureToggleService
            .reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateItems()
            }
            .store(in: &bag)
        Installations.installations().installationID { [weak self] id, error in
            self?.state.installationId = id
        }
        updateItems()
        render()
        updateMenu()
    }

    private func render() {
        let togglesCells: [any IdentifiableComponent] = state.items.map { item in
            ToggleComponent(
                id: item.key,
                color: item.color,
                colorText: item.colorText,
                title: item.key,
                value: item.value,
                isExpanded: state.isExpanded,
                onSelect: { [weak self] in
                    self?.coordinator?.open(anyFeatureToggle: item.anyFeatureToggle)
                }
            )
        }

        var infoCells: [any IdentifiableComponent] = [getTimeCell()]
        if let installationId = state.installationId {
            infoCells.append(
                ListComponent(
                    id: "installation_id",
                    title: "Installation id",
                    value: installationId,
                    selectableContext: .init(
                        shouldDeselect: true,
                        onSelect: {
                            UIPasteboard.general.string = installationId
                            SPIndicator.present(title: "Copied", preset: .done)
                        }
                    )
                )
            )
        }

        delegate?.render(sections: [
            ComponentSection(
                id: "firebase_info",
                cells: infoCells
            ),
            ComponentSection(
                id: "all_toggles",
                cells: togglesCells
            )
        ])
    }

    private func updateItems() {
        let featureToggles = featureToggleService.allToggles
        state.items = featureToggles.map {
            let value = featureToggleService.getAnyValue(anyFeatureToggle: $0)
            let isJSON = value.valueType is PizzaFeatureToggleJSONValueType.Type
            let isOptional = Mirror(reflecting: value.anyValue).displayStyle == .optional
            let color: UIColor = {
                switch value.responseType {
                case .fromOverride:
                    return .systemGreen
                case .fromRemoteConfig:
                    return .systemBlue
                case .default:
                    return .systemGray
                }
            }()
            let colorText: String = {
                switch value.responseType {
                case .fromOverride:
                    return "override"
                case .fromRemoteConfig:
                    return "remote"
                case .default:
                    return "default"
                }
            }()
            return .init(
                key: $0.key,
                value: isJSON 
                    ? "JSON"
                    : (isOptional ? "Optional" : value.anyValue.description),
                color: color.lighter(by: 0.2),
                colorText: colorText,
                anyFeatureToggle: $0
            )
        }
    }

    private func getSecondsDifferenceFromTwoDates(start: Date, end: Date) -> Int {
        return Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
    }

    private func getTimeCell() -> any IdentifiableComponent {
        let title = "Last fetch time"
        guard let date = featureToggleService.lastFetchDate else {
            return ListComponent(
                id: "last_fetch_time_never",
                title: title,
                value: "never"
            )
        }
        let onSelect: PizzaEmptyClosure = { [weak self] in
            guard let self else { return }
            self.state.preferReferencedTime.toggle()
            Defaults[.preferReferencedTimeKey] = self.state.preferReferencedTime
        }
        if state.preferReferencedTime {
            return TitleTimeComponent(
                id: "last_fetch_time_reference",
                title: title,
                onGetString: { [weak self] currentDate in
                    let timeSecondsDiff = self?.getSecondsDifferenceFromTwoDates(
                        start: date,
                        end: currentDate
                    ) ?? 0
                    if timeSecondsDiff >= 60 {
                        return "\(Int(timeSecondsDiff / 60)) minutes ago"
                    }
                    return "\(timeSecondsDiff) seconds ago"
                },
                onSelect: onSelect
            )
        }
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.timeStyle = .medium
        dateTimeFormatter.dateStyle = .short
        let dateString = dateTimeFormatter.string(from: date)
        return ListComponent(
            id: "last_fetch_time_date",
            title: title,
            value: dateString,
            selectableContext: .init(
                shouldDeselect: true,
                onSelect: onSelect
            )
        )
    }

    private func updateMenu() {
        delegate?.controller.do {
            $0.navigationItem.rightBarButtonItem = .init(
                image: UIImage(
                    systemSymbol: .paintbrush,
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)
                ),
                menu: UIMenu(
                    children: [
                        UIAction(
                            title: state.isExpanded
                                ? "Hide tags"
                                : "Show tags",
                            image: UIImage(
                                systemSymbol: state.isExpanded
                                    ? .tagFill
                                    : .tag,
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)
                            ),
                            handler: { [weak self] _ in
                                self?.toggleExpanded()
                            }
                        )
                    ]
                )
            )
        }
    }

    private func toggleExpanded() {
        state.isExpanded.toggle()
        Defaults[.isExpanded] = state.isExpanded
        updateMenu()
    }

}

fileprivate extension Defaults.Keys {
    static let preferReferencedTimeKey = Defaults.Key("ft_prefReferencedTimeKey", default: false)
    static let isExpanded = Defaults.Key("ft_isExpanded", default: false)
}
