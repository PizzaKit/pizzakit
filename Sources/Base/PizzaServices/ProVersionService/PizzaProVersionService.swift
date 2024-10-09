import PizzaCore
import Foundation
import Combine
import UIKit

public struct ProVersionState {
    /// текущее значение (выставленное на основе покупок/подписок)
    var value: Bool
    
    /// нужно ли перезатирать текущее значение
    var shouldForce: Bool
    
    /// каким значением нужно перезатирать
    var forceValue: Bool

    public var isPro: Bool {
        (shouldForce && forceValue) || (!shouldForce && value)
    }
}

public protocol PizzaProVersionService {
    var valuePublisher: PizzaRPublisher<Bool, Never> { get }

    func setValue(_ value: Bool)
    func setForceValue(shouldForce: Bool, forceValue: Bool)
}

public class PizzaProVersionServiceImpl: PizzaProVersionService {

    // MARK: - Properties

    private var state = ProVersionState(
        value: false,
        shouldForce: false,
        forceValue: false
    ) {
        didSet {
            _valuePublisher.setNeedsUpdate()
        }
    }
    private lazy var _valuePublisher = PizzaPassthroughRPublisher<Bool, Never>(
        currentValue: { [weak self] in
            self?.state.isPro ?? false
        }
    )

    public var valuePublisher: PizzaRPublisher<Bool, Never> {
        _valuePublisher
    }

    // MARK: - Initalization

    public init() {}

    // MARK: - Public Methods

    public func setValue(_ value: Bool) {
        state.value = value
    }

    public func setForceValue(shouldForce: Bool, forceValue: Bool) {
        var newState = state
        newState.forceValue = forceValue
        newState.shouldForce = shouldForce
        state = newState
    }

}
