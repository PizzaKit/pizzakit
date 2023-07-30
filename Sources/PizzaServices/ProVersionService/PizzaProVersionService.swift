import PizzaCore
import Foundation
import Combine
import UIKit

public struct ProVersionState {
    let value: Bool
    let forceValue: Bool

    public var isPro: Bool {
        forceValue || value
    }
}

public protocol PizzaProVersionService {
    var value: Bool { get }
    var valuePublisher: AnyPublisher<Bool, Never> { get }

    func setValue(_ value: Bool)
    func setForceValue(_ forceValue: Bool)
}

public class PizzaProVersionServiceImpl: PizzaProVersionService {

    // MARK: - Properties

    public var valuePublisher: AnyPublisher<Bool, Never> {
        currentValueSubject
            .map { $0.isPro }
            .eraseToAnyPublisher()
    }
    public var value: Bool {
        currentValueSubject.value.isPro
    }

    private let currentValueSubject: CurrentValueSubject<ProVersionState, Never>
    private var bag = Set<AnyCancellable>()

    // MARK: - Initalization

    public init() {
        currentValueSubject = .init(.init(value: false, forceValue: false))
    }

    // MARK: - Public Methods

    public func setValue(_ value: Bool) {
        let currentState = currentValueSubject.value
        currentValueSubject.send(.init(value: value, forceValue: currentState.forceValue))
    }

    public func setForceValue(_ forceValue: Bool) {
        let currentState = currentValueSubject.value
        currentValueSubject.send(.init(value: currentState.value, forceValue: forceValue))
    }

}
