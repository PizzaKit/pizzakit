import Foundation
import PizzaServices
import Combine

public enum PizzaFeatureToggleTypeRegister {
    public static var allTypes: [PizzaFeatureToggleValueType.Type] = []
}

public protocol PizzaFeatureToggleService {

    var lastFetchDate: Date? { get }

    /// PasstroughSubject - вызывается только при reload-е
    var reloadPublisher: AnyPublisher<Void, Never> { get }

    /// Под капотом CurrentValueSubject - поэтому при подписке сразу вызывается.
    /// Bool отражает загружены ли тогглы или нет
    var initialLoadingFromNetworkPublisher: AnyPublisher<Bool, Never> { get }
    var allToggles: [PizzaAnyFeatureToggle] { get }

    /// Method for initial fetching remoteConfig
    /// - Parameter fetchInterval: fetch interval in which publisher will be returned
    /// - Returns: publisher that will be fired maximum at fetchInterval seconds
    /// or earlier. True means that toggles was fetched and activated. False -
    /// toggles will be activated later
    func tryFetchAndActivate(
        fetchInterval: TimeInterval
    ) -> AnyPublisher<Bool, Never>

    // Typed Values

    func getValue<T: PizzaFeatureToggleValueType>(
        featureToggle: PizzaFeatureToggle<T>,
        responseType: PizzaFeatureToggleResponseType
    ) -> PizzaFeatureToggleValue<T>?

    func getValue<T: PizzaFeatureToggleValueType>(
        featureToggle: PizzaFeatureToggle<T>
    ) -> PizzaFeatureToggleValue<T>

    // Any values

    func getAnyValue(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        responseType: PizzaFeatureToggleResponseType
    ) -> PizzaAnyFeatureToggleValue?

    func getAnyValue(
        anyFeatureToggle: PizzaAnyFeatureToggle
    ) -> PizzaAnyFeatureToggleValue

    // Typed Override

    func setOverride<T: PizzaFeatureToggleValueType>(
        forFeatureToggle featureToggle: PizzaFeatureToggle<T>,
        overrideValue: PizzaFeatureToggleOverrideValue<T>
    )

    // Any Override

    func setAnyOverride(
        forAnyFeatureToggle anyFeatureToggle: PizzaAnyFeatureToggle,
        anyOverrideValue: PizzaAnyFeatureToggleOverrideValue
    )
    func getAnyOverride(
        forAnyFeatureToggle anyFeatureToggle: PizzaAnyFeatureToggle
    ) -> PizzaAnyFeatureToggleOverrideValue?

}
