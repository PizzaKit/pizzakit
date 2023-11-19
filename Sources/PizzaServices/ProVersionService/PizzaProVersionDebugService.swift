import Defaults
import PizzaCore
import Combine
import Foundation

public struct PizzaProVersionDebugState: Codable, Defaults.Serializable {
    public var shouldForce: Bool
    public var forceValue: Bool

    public init(shouldForce: Bool, forceValue: Bool) {
        self.shouldForce = shouldForce
        self.forceValue = forceValue
    }
}

/// Сервис для включения force pro версии.
/// Значение хранится в UserDefaults, но значение в ProVersionService будет выставлено
/// толко если включен developerMode (или debug build) и текущий флаг true
public protocol PizzaProVersionDebugService: AnyObject {

    var isForcedProVersionPublisher: PizzaRWPublisher<PizzaProVersionDebugState, Never> { get }

    /// Нужно вызывать при старте приложения (или при обновлении виджета)
    /// чтобы проверка в `proVersionService` учитывала debugMode
    func checkForceProVersion()

}

public class PizzaProVersionDebugServiceImpl: PizzaProVersionDebugService {

    public typealias State = PizzaProVersionDebugState

    private lazy var _isForcedProVersionPublisher = PizzaPassthroughRWPublisher<State, Never>(
        currentValue: { [weak self] in
            guard let self else { return .init(shouldForce: false, forceValue: false) }
            return Defaults[.forceProVersion(appGroup: self.appGroup)]
        },
        onValueChanged: { [weak self] newValue in
            self?.set(state: newValue)
        }
    )
    public var isForcedProVersionPublisher: PizzaRWPublisher<State, Never> {
        _isForcedProVersionPublisher
    }

    private let proVersionService: PizzaProVersionService
    private let developerModeService: PizzaDeveloperModeService
    private let appGroup: String?

    private var bag = Set<AnyCancellable>()

    public init(
        proVersionService: PizzaProVersionService,
        developerModeService: PizzaDeveloperModeService,
        appGroup: String?
    ) {
        self.proVersionService = proVersionService
        self.developerModeService = developerModeService
        self.appGroup = appGroup

        developerModeService
            .valuePublisher
            .withoutCurrentValue
            .sink { [weak self] _ in
                self?.checkForceProVersion()
            }
            .store(in: &bag)
    }

    // MARK: - PizzaProVersionDebugService

    public func checkForceProVersion() {
        let isDeveloperMode = developerModeService.valuePublisher.value
        let state = Defaults[.forceProVersion(appGroup: appGroup)]
        proVersionService.setForceValue(
            shouldForce: isDeveloperMode && state.shouldForce,
            forceValue: state.forceValue
        )
    }

    // MARK: - Private Methods

    private func set(state: State) {
        Defaults[.forceProVersion(appGroup: appGroup)] = state
        checkForceProVersion()
    }

}

fileprivate extension Defaults.Keys {
    static func forceProVersion(appGroup: String?) -> Defaults.Key<PizzaProVersionDebugState> {
        Defaults.Key<PizzaProVersionDebugState>(
            "forceProVersion_state",
            default: PizzaProVersionDebugState(shouldForce: false, forceValue: true),
            suite: UserDefaults(suiteName: appGroup) ?? .standard
        )
    }
}
