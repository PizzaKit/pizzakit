import PizzaCore
import Foundation
import Combine
import UIKit

public protocol PizzaProVersionService {
    var value: Bool { get }
    var valueSubject: AnyPublisher<Bool, Never> { get }
}

public protocol PizzaProVersionWritableService: PizzaProVersionService {
    var value: Bool { get set }
}

public class PizzaProVersionServiceImpl: PizzaProVersionWritableService {

    // MARK: - Properties

    public var valueSubject: AnyPublisher<Bool, Never> {
        currentValueSubject.eraseToAnyPublisher()
    }
    public var value: Bool {
        get {
            currentValueSubject.value
        }
        set {
            currentValueSubject.send(newValue)
        }
    }

    private let currentValueSubject: CurrentValueSubject<Bool, Never>
    private var bag = Set<AnyCancellable>()

    // MARK: - Initalization

    public init() {
        currentValueSubject = .init(false)
    }

}
