import Defaults
import PizzaCore
import Combine

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

    func initialize()

}

public class PizzaProVersionDebugServiceImpl: PizzaProVersionDebugService {

    public typealias State = PizzaProVersionDebugState

    private lazy var _isForcedProVersionPublisher = PizzaPassthroughRWPublisher<State, Never>(
        currentValue: {
            Defaults[.forceProVersion]
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

    private var bag = Set<AnyCancellable>()

    public init(
        proVersionService: PizzaProVersionService,
        developerModeService: PizzaDeveloperModeService
    ) {
        self.proVersionService = proVersionService
        self.developerModeService = developerModeService
    }

    // MARK: - PizzaProVersionDebugService

    public func initialize() {
        developerModeService
            .valuePublisher
            .withoutCurrentValue
            .sink { [weak self] _ in
                self?.checkForceProVersionService()
            }
            .store(in: &bag)
        checkForceProVersionService()
    }

    // MARK: - Private Methods

    private func set(state: State) {
        Defaults[.forceProVersion] = state
        checkForceProVersionService()
    }

    private func checkForceProVersionService() {
        let isDeveloperMode = developerModeService.valuePublisher.value
        let state = Defaults[.forceProVersion]
        proVersionService.setForceValue(
            shouldForce: isDeveloperMode && state.shouldForce,
            forceValue: state.forceValue
        )
    }

}

fileprivate extension Defaults.Keys {
    static let forceProVersion = Defaults.Key<PizzaProVersionDebugState>(
        "forceProVersion_state",
        default: PizzaProVersionDebugState(shouldForce: false, forceValue: true)
    )
}
