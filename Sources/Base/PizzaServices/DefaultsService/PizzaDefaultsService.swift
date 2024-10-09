import PizzaCore
import Foundation
import Combine
import Defaults

public protocol PizzaDefaultsServiceStorageItem: Defaults.Serializable {
    static var key: String { get }
    static var `default`: Self { get }
}

open class PizzaDefaultsService<StorageItem: PizzaDefaultsServiceStorageItem> {

    // MARK: - Properties

    private lazy var key = Defaults.Key<StorageItem>(
        StorageItem.key,
        default: StorageItem.default,
        suite: UserDefaults(suiteName: appGroup) ?? .standard
    )
    public lazy var valuePublisher: PizzaRWPublisher<StorageItem, Never> = PizzaPassthroughRWPublisher(
        currentValue: { [weak self] in
            guard let self else { return .default }
            return Defaults[self.key]
        },
        onValueChanged: { [weak self] in
            guard let self else { return }
            Defaults[self.key] = $0
            self.valueChanged()
        }
    )

    private let appGroup: String?

    // MARK: - Initalization

    public init(appGroup: String?) {
        self.appGroup = appGroup
    }

    // MARK: - Methods to override

    open func valueChanged() {}

}
