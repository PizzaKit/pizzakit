import Foundation
import Defaults

/// Фича тоггл описывается классом `PizzaFeatureToggle<T>` и протоколом `PizzaAnyFeatureToggle`.
/// Идея в том, что есть generic класс нужно использовать в коде, а вся работа внутри
/// идет с протоколом (потому что такие значения можно хранить вместе - потому что
/// не дженерик, информация о типе так же присутствует)

public protocol PizzaAnyFeatureToggle {
    /// Ключ для фича тоггла - соответствует имени в FirebaseRemoteConfig
    var key: String { get }

    /// Дефолтное значение
    var defaultAnyValue: PizzaFeatureToggleValueType { get }

    /// Тип значения
    var valueType: PizzaFeatureToggleValueType.Type { get }
}

public struct PizzaFeatureToggle<T: PizzaFeatureToggleValueType>: PizzaAnyFeatureToggle {

    public let key: String
    public let defaultValue: T
    public var valueType: PizzaFeatureToggleValueType.Type {
        T.self
    }
    public var defaultAnyValue: PizzaFeatureToggleValueType {
        defaultValue
    }

    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

}

/// Место, откуда значение пришло
public enum PizzaFeatureToggleResponseType: String {
    /// Не пришел remoteConfig - выставленный default
    case `default`

    /// RemoteConfig пришел и значение оттуда
    case fromRemoteConfig

    /// Локально переопределено значение
    case fromOverride
}

public struct PizzaAnyFeatureToggleValue {
    public let anyValue: PizzaFeatureToggleValueType
    public let valueType: PizzaFeatureToggleValueType.Type
    public let responseType: PizzaFeatureToggleResponseType

    public init(
        anyValue: PizzaFeatureToggleValueType,
        valueType: PizzaFeatureToggleValueType.Type,
        responseType: PizzaFeatureToggleResponseType
    ) {
        self.anyValue = anyValue
        self.valueType = valueType
        self.responseType = responseType
    }
}

public struct PizzaFeatureToggleValue<T: PizzaFeatureToggleValueType> {
    public let value: T
    public let responseType: PizzaFeatureToggleResponseType

    public init(value: T, responseType: PizzaFeatureToggleResponseType) {
        self.value = value
        self.responseType = responseType
    }
}

public struct PizzaAnyFeatureToggleOverrideValue: Codable, Defaults.Serializable {

    enum CodableError: Error {
        case noValueType
    }

    enum CodingKeys: CodingKey {
        case value
        case valueType
        case isOverrideEnabled
    }

    public let value: PizzaFeatureToggleValueType
    public let valueType: PizzaFeatureToggleValueType.Type
    public let isOverrideEnabled: Bool

    public init(value: PizzaFeatureToggleValueType, valueType: PizzaFeatureToggleValueType.Type, isOverrideEnabled: Bool) {
        self.value = value
        self.valueType = valueType
        self.isOverrideEnabled = isOverrideEnabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let valueStringType = try container.decode(String.self, forKey: .valueType)
        guard let valueType = PizzaFeatureToggleTypeRegister.allTypes
            .first(where: { String(describing: $0) == valueStringType })
        else { throw CodableError.noValueType }
        self.valueType = valueType
        value = try container.decode(valueType, forKey: .value)
        isOverrideEnabled = try container.decode(Bool.self, forKey: .isOverrideEnabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(String(describing: valueType), forKey: .valueType)
        try container.encode(value, forKey: .value)
        try container.encode(isOverrideEnabled, forKey: .isOverrideEnabled)
    }
}

public struct PizzaFeatureToggleOverrideValue<T: PizzaFeatureToggleValueType> {
    public let value: T
    public let isOverrideEnabled: Bool

    public var anyValue: PizzaAnyFeatureToggleOverrideValue {
        .init(
            value: value,
            valueType: T.self,
            isOverrideEnabled: isOverrideEnabled
        )
    }

    public init(value: T, isOverrideEnabled: Bool) {
        self.value = value
        self.isOverrideEnabled = isOverrideEnabled
    }
}

public protocol PizzaFeatureToggleJSONValueType: PizzaFeatureToggleValueType {}

extension Array: PizzaFeatureToggleValueType where Element: PizzaFeatureToggleValueType {

    public static func extractFrom(remoteValue: PizzaFeatureToggleRemoteValue) -> Array<Element>? {
        return .from(string: remoteValue.stringValue)
    }

    public var nsObjectValue: NSObject {
        NSString(string: getString() ?? "")
    }

}

public extension PizzaFeatureToggleJSONValueType {
    static func extractFrom(
        remoteValue: PizzaFeatureToggleRemoteValue
    ) -> Self? {
        return .from(string: remoteValue.stringValue)
    }
    var nsObjectValue: NSObject {
        NSString(string: getString() ?? "")
    }
}

public protocol PizzaFeatureToggleRemoteValue {
    var stringValue: String { get }
    var numberValue: NSNumber { get }
    var dataValue: Data { get }
    var boolValue: Bool { get }
    var jsonValue: Any? { get }
}

public protocol PizzaFeatureToggleValueType: Codable, CustomStringConvertible {
    static func extractFrom(
        remoteValue: PizzaFeatureToggleRemoteValue
    ) -> Self?
    var nsObjectValue: NSObject { get }
}

extension Optional: PizzaFeatureToggleValueType, CustomStringConvertible where Wrapped: PizzaFeatureToggleValueType {

    public static func extractFrom(
        remoteValue: PizzaFeatureToggleRemoteValue
    ) -> Optional<Wrapped>? {
        if let extracted = Wrapped.extractFrom(remoteValue: remoteValue) {
            return .some(extracted)
        }
        return .none
    }
    
    public var nsObjectValue: NSObject {
        switch self {
        case .some(let value):
            return value.nsObjectValue
        case .none:
            return NSNull()
        }
    }
    
    public var description: String {
        switch self {
        case .some(let value):
            return value.description
        case .none:
            return "nil"
        }
    }
}

extension String: PizzaFeatureToggleValueType {
    public static func extractFrom(
        remoteValue: PizzaFeatureToggleRemoteValue
    ) -> String? {
        remoteValue.stringValue
    }
    public var nsObjectValue: NSObject {
        NSString(string: self)
    }
}

extension Int: PizzaFeatureToggleValueType {
    public static func extractFrom(
        remoteValue: PizzaFeatureToggleRemoteValue
    ) -> Int? {
        remoteValue.numberValue.intValue
    }
    public var nsObjectValue: NSObject {
        NSNumber(integerLiteral: self)
    }
}

extension Bool: PizzaFeatureToggleValueType {
    public static func extractFrom(
        remoteValue: PizzaFeatureToggleRemoteValue
    ) -> Bool? {
        remoteValue.boolValue
    }
    public var nsObjectValue: NSObject {
        NSNumber(booleanLiteral: self)
    }
}
