import PizzaServices
import FirebaseRemoteConfig
import Combine
import Foundation
import Defaults

extension RemoteConfigValue: PizzaFeatureToggleRemoteValue {}

public class PizzaFirebaseFeatureToggleService: PizzaFeatureToggleService {

    // MARK: - Constants

    private enum Constants {
        static let overridePrefix = "pizza_firebase_feature_toggle_override_"
    }

    // MARK: - Properties

    private let remoteConfig: RemoteConfig
    public let allToggles: [PizzaAnyFeatureToggle]
    public var reloadPublisher: AnyPublisher<Void, Never> {
        reloadSubject.eraseToAnyPublisher()
    }
    public var initialLoadingFromNetworkPublisher: AnyPublisher<Bool, Never> {
        initialLoadingFromNetworkSubject.eraseToAnyPublisher()
    }
    public var lastFetchDate: Date? {
        remoteConfig.lastFetchTime
    }

    private var timer: Timer?

    private var bag = Set<AnyCancellable>()
    private let reloadSubject = PassthroughSubject<Void, Never>()
    private let initialLoadingFromNetworkSubject = CurrentValueSubject<Bool, Never>(false)

    /// ToggleService initialization
    /// - Parameter fetchInterval: nil for default
    public init(
        fetchInterval: TimeInterval?,
        toggles: [PizzaAnyFeatureToggle]
    ) {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        if let fetchInterval {
            settings.minimumFetchInterval = fetchInterval
        }
        settings.fetchTimeout = 10 // seconds to wait response from server, then fail
        remoteConfig.configSettings = settings
        self.allToggles = toggles

        // configure defaults
        var allDefaults: [String: NSObject] = [:]
        for toggle in toggles {
            allDefaults[toggle.key] = toggle.defaultAnyValue.nsObjectValue
        }
        remoteConfig.setDefaults(allDefaults)

        // log values
        reloadSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.printCurrentToggles()
            })
            .store(in: &bag)
        let startTime = Date().timeIntervalSince1970
        initialLoadingFromNetworkPublisher
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                let endTime = Date().timeIntervalSince1970
                let diffInSeconds = endTime - startTime
                let round = Double(Int(diffInSeconds * 100)) / 100

                PizzaLogger.log(
                    label: "feature_toggle",
                    level: .info,
                    message: "Feature toggles was received from server with \(round) seconds"
                )
            }
            .store(in: &bag)

        // fill types
        PizzaFeatureToggleTypeRegister.allTypes = toggles.map { $0.valueType }
    }

    // MARK: - Methods

    @discardableResult
    public func tryFetchAndActivate(
        fetchInterval: TimeInterval
    ) -> AnyPublisher<Bool, Never> {
        let responsePublisher = PassthroughSubject<Bool, Never>()

        let timer = Timer.publish(
            every: fetchInterval,
            tolerance: nil,
            on: .main,
            in: .common
        ).autoconnect()

        timer.sink { _ in
            timer.upstream.connect().cancel()

            responsePublisher.send(false)
            responsePublisher.send(completion: .finished)
        }
        .store(in: &bag)

        let start = Date().timeIntervalSince1970
        remoteConfig.fetchAndActivate { [weak self] _, _ in
            timer.upstream.connect().cancel()

            let end = Date().timeIntervalSince1970
            let diff = end - start
            print("Feature toggle fetched with \(diff) seconds")

            self?.initialLoadingFromNetworkSubject.send(true)
            self?.reloadSubject.send(())

            responsePublisher.send(true)
            responsePublisher.send(completion: .finished)

            self?.startObserving()
        }

        return responsePublisher.eraseToAnyPublisher()
    }

    public func getValue<T: PizzaFeatureToggleValueType>(
        featureToggle: PizzaFeatureToggle<T>,
        responseType: PizzaFeatureToggleResponseType
    ) -> PizzaFeatureToggleValue<T>? {
        switch responseType {
        case .default:
            let defaultValue = featureToggle.defaultValue
            return .init(
                value: defaultValue,
                responseType: .default
            )
        case .fromRemoteConfig:
            let remoteConfigValue = remoteConfig.configValue(forKey: featureToggle.key)
            guard
                let value = T.extractFrom(remoteValue: remoteConfigValue),
                remoteConfigValue.source == .remote
            else { return nil }
            return PizzaFeatureToggleValue<T>(
                value: value,
                responseType: .fromRemoteConfig
            )
        case .fromOverride:
            let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
                Constants.overridePrefix + featureToggle.key
            )
            guard
                let override = Defaults[key],
                let overrideValue = override.value as? T
            else { return nil }
            return .init(
                value: overrideValue,
                responseType: .fromOverride
            )
        }
    }

    public func getValue<T: PizzaFeatureToggleValueType>(
        featureToggle: PizzaFeatureToggle<T>
    ) -> PizzaFeatureToggleValue<T> {
        guard allToggles.contains(where: { $0.key == featureToggle.key }) else {
            return .init(
                value: featureToggle.defaultValue,
                responseType: .default
            )
        }

        let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
            Constants.overridePrefix + featureToggle.key
        )
        if
            let override = Defaults[key],
            override.isOverrideEnabled,
            let overrideValue = override.value as? T
        {
            return .init(
                value: overrideValue,
                responseType: .fromOverride
            )
        }

        let remoteConfigValue = remoteConfig.configValue(forKey: featureToggle.key)
        return .init(
            value: .extractFrom(
                remoteValue: remoteConfigValue
            ) ?? featureToggle.defaultValue,
            responseType: remoteConfigValue.source == .remote
                ? .fromRemoteConfig
                : .default
        )
    }

    public func getAnyValue(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        responseType: PizzaFeatureToggleResponseType
    ) -> PizzaAnyFeatureToggleValue? {
        switch responseType {
        case .default:
            let defaultValue = anyFeatureToggle.defaultAnyValue
            return .init(
                anyValue: defaultValue,
                valueType: anyFeatureToggle.valueType,
                responseType: .default
            )
        case .fromRemoteConfig:
            let remoteConfigValue = remoteConfig.configValue(
                forKey: anyFeatureToggle.key
            )
            guard
                let value = anyFeatureToggle.valueType
                    .extractFrom(remoteValue: remoteConfigValue),
                remoteConfigValue.source == .remote
            else { return nil }
            return .init(
                anyValue: value,
                valueType: anyFeatureToggle.valueType,
                responseType: .fromRemoteConfig
            )
        case .fromOverride:
            let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
                Constants.overridePrefix + anyFeatureToggle.key
            )
            guard let override = Defaults[key] else { return nil }
            return .init(
                anyValue: override.value,
                valueType: anyFeatureToggle.valueType,
                responseType: .fromOverride
            )
        }
    }

    public func getAnyValue(
        anyFeatureToggle: PizzaAnyFeatureToggle
    ) -> PizzaAnyFeatureToggleValue {
        guard allToggles.contains(where: { $0.key == anyFeatureToggle.key }) else {
            return .init(
                anyValue: anyFeatureToggle.defaultAnyValue,
                valueType: anyFeatureToggle.valueType,
                responseType: .default
            )
        }

        let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
            Constants.overridePrefix + anyFeatureToggle.key
        )
        if
            let override = Defaults[key],
            override.isOverrideEnabled
        {
            return .init(
                anyValue: override.value,
                valueType: anyFeatureToggle.valueType,
                responseType: .fromOverride
            )
        }

        let remoteConfigValue = remoteConfig
            .configValue(forKey: anyFeatureToggle.key)
        return .init(
            anyValue: anyFeatureToggle.valueType.extractFrom(
                remoteValue: remoteConfigValue
            ) ?? anyFeatureToggle.defaultAnyValue,
            valueType: anyFeatureToggle.valueType,
            responseType: remoteConfigValue.source == .remote
                ? .fromRemoteConfig
                : .default
        )
    }

    public func setOverride<T: PizzaFeatureToggleValueType>(
        forFeatureToggle featureToggle: PizzaFeatureToggle<T>,
        overrideValue: PizzaFeatureToggleOverrideValue<T>
    ) {
        let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
            Constants.overridePrefix + featureToggle.key
        )
        Defaults[key] = overrideValue.anyValue
        reloadSubject.send(())
    }

    public func setAnyOverride(
        forAnyFeatureToggle anyFeatureToggle: PizzaAnyFeatureToggle,
        anyOverrideValue: PizzaAnyFeatureToggleOverrideValue
    ) {
        let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
            Constants.overridePrefix + anyFeatureToggle.key
        )
        Defaults[key] = anyOverrideValue
        reloadSubject.send(())
    }

    public func getAnyOverride(
        forAnyFeatureToggle anyFeatureToggle: PizzaAnyFeatureToggle
    ) -> PizzaAnyFeatureToggleOverrideValue? {
        let key = Defaults.Key<PizzaAnyFeatureToggleOverrideValue?>(
            Constants.overridePrefix + anyFeatureToggle.key
        )
        return Defaults[key]
    }

    // MARK: - Private Methods

    private func startObserving() {
        remoteConfig.addOnConfigUpdateListener(remoteConfigUpdateCompletion: { [weak self] update, error in
            guard let update, error == nil else { return }

            self?.remoteConfig.activate(completion: { activated, error in
                guard activated, error == nil else { return }
                self?.reloadSubject.send(())
            })
        })
    }

    private func printCurrentToggles() {
        var payload: [String: Any] = [:]
        for toggle in allToggles {
            let toggleValue = getAnyValue(anyFeatureToggle: toggle)
            payload[toggle.key] = toggleValue.anyValue
            payload[toggle.key + "_source"] = toggleValue.responseType.rawValue
        }
        PizzaLogger.log(
            label: "feature_toggle",
            level: .info,
            message: "Feature toggles updated",
            payload: payload
        )
    }
    
}
