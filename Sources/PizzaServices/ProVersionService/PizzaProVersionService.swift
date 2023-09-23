import PizzaCore
import Foundation
import Combine
import UIKit

public struct ProVersionState {
    var value: Bool
    var forceValue: Bool

    public var isPro: Bool {
        forceValue || value
    }
}

public protocol PizzaProVersionService {
    var valuePublisher: PizzaRPublisher<Bool, Never> { get }

    func setValue(_ value: Bool)
    func setForceValue(_ forceValue: Bool)
}

public class PizzaProVersionServiceImpl: PizzaProVersionService {

    // MARK: - Properties

    private var state = ProVersionState(value: false, forceValue: false) {
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

    public func setForceValue(_ forceValue: Bool) {
        state.forceValue = forceValue
    }

}
