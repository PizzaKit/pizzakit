import PizzaKit
import Foundation
import FirebaseInstallations
import UIKit
import SPIndicator
import Combine
import SFSafeSymbols

public class FeatureTogglesListPresenter: FormPresenter {

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

    public weak var delegate: FormPresenterDelegate?
    private let featureToggleService: PizzaFeatureToggleService
    private let router: PizzaFeatureToggleUIRouter
    private var state: State {
        didSet { render() }
    }
    private var bag = Set<AnyCancellable>()

    public init(
        featureToggleService: PizzaFeatureToggleService,
        router: PizzaFeatureToggleUIRouter
    ) {
        self.featureToggleService = featureToggleService
        self.router = router
        self.state = .init(
            items: [],
            preferReferencedTime: UserDefaults.standard.preferReferencedTimeKey,
            isExpanded: UserDefaults.standard.isExpanded
        )

    }

    public func touch() {
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
        let togglesCells: [CellNode] = state.items.map { item in
            .init(
                component: ToggleComponent(
                    id: item.key,
                    color: item.color,
                    colorText: item.colorText,
                    title: item.key,
                    value: item.value,
                    isExpanded: state.isExpanded,
                    onSelect: { [weak self] in
                        self?.router.open(anyFeatureToggle: item.anyFeatureToggle)
                    }
                )
            )
        }

        var infoCells: [CellNode] = [getTimeCell()]
        if let installationId = state.installationId {
            infoCells.append(.init(component: TitleValueSelectableComponent(
                id: "installation_id",
                title: "Installation id",
                description: installationId,
                style: .default,
                shouldDeselect: true,
                onSelect: {
                    UIPasteboard.general.string = installationId
                    SPIndicator.present(title: "Copied", preset: .done)
                }
            )))
        }

        delegate?.render(sections: [
            Section(
                id: "firebase_info",
                cells: infoCells
            ),
            Section(
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
                value: isJSON ? "JSON" : value.anyValue.description,
                color: color.lighter(by: 0.2),
                colorText: colorText,
                anyFeatureToggle: $0
            )
        }
    }

    private func getSecondsDifferenceFromTwoDates(start: Date, end: Date) -> Int {
        return Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
    }

    private func getTimeCell() -> CellNode {
        let title = "Last fetch time"
        guard let date = featureToggleService.lastFetchDate else {
            return .init(component: TitleValueComponent(
                id: "last_fetch_time_never",
                title: title,
                description: "never",
                style: .default
            ))
        }
        let onSelect: PizzaEmptyClosure = { [weak self] in
            guard let self else { return }
            self.state.preferReferencedTime.toggle()
            UserDefaults.standard.preferReferencedTimeKey = self.state.preferReferencedTime
        }
        if state.preferReferencedTime {
            return .init(
                component: TitleTimeComponent(
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
                    style: .default,
                    onSelect: onSelect
                )
            )
        }
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.timeStyle = .medium
        dateTimeFormatter.dateStyle = .short
        let dateString = dateTimeFormatter.string(from: date)
        return .init(
            component: TitleValueSelectableComponent(
                id: "last_fetch_time_date",
                title: title,
                description: dateString,
                style: .default,
                shouldDeselect: true,
                onSelect: onSelect
            )
        )
    }

    private func updateMenu() {
        delegate?.modify {
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
        UserDefaults.standard.isExpanded = state.isExpanded
        updateMenu()
    }

}

private extension UserDefaults {

    var preferReferencedTimeKey: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

    var isExpanded: Bool {
        get { UserDefaults.standard.bool(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }

}
