import Combine
import PizzaCore
import Defaults

public protocol PizzaAnalyticsDebugService {

    /// Publisher который показывает текущее состояние настройки (можно менять)
    var showDebugViewPublisher: PizzaRWPublisher<Bool, Never> { get }

    /// Publisher который показывает текущее состояние view видимости
    var onVisibilityChangedPublisher: PizzaRPublisher<Bool, Never> { get }

    func initialize()

}

public class PizzaAnalyticsDebugServiceImpl: PizzaAnalyticsDebugService {

    // MARK: - Properties

    private lazy var _showDebugViewPublisher = PizzaPassthroughRWPublisher<Bool, Never>(
        currentValue: {
            Defaults[.showAnalyticsView]
        },
        onValueChanged: { [weak self] newValue in
            Defaults[.showAnalyticsView] = newValue
            self?.checkViewVisibility()
        }
    )
    public var showDebugViewPublisher: PizzaRWPublisher<Bool, Never> {
        _showDebugViewPublisher
    }

    private var viewVisible = false {
        didSet {
            _onVisibilityChangedPublisher.setNeedsUpdate()
        }
    }
    private lazy var _onVisibilityChangedPublisher = PizzaPassthroughRPublisher<Bool, Never>(
        currentValue: { [weak self] in
            self?.viewVisible ?? false
        }
    )
    public var onVisibilityChangedPublisher: PizzaRPublisher<Bool, Never> {
        _onVisibilityChangedPublisher
    }

    private let developerModeService: PizzaDeveloperModeService

    private var bag = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        developerModeService: PizzaDeveloperModeService
    ) {
        self.developerModeService = developerModeService
    }

    // MARK: - AnalyticsDebugService

    public func initialize() {
        developerModeService
            .valuePublisher
            .withoutCurrentValue
            .sink { [weak self] _ in
                self?.checkViewVisibility()
            }
            .store(in: &bag)
        checkViewVisibility()
    }

    // MARK: - Private Methods

    private func checkViewVisibility() {
        let isDeveloperMode = developerModeService.valuePublisher.value
        viewVisible = Defaults[.showAnalyticsView] && isDeveloperMode
    }

}

fileprivate extension Defaults.Keys {
    static let showAnalyticsView = Defaults.Key<Bool>("showAnalyticsView", default: false)
}
