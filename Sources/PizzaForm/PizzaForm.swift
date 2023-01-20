import DifferenceKit
import PizzaKit

public struct PizzaFormSimpleListItem: PizzaFormItem, Equatable, PizzaFormSelectableItem {
    public static func == (lhs: PizzaFormSimpleListItem, rhs: PizzaFormSimpleListItem) -> Bool {
        return lhs.id == rhs.id
            && lhs.colorHex == rhs.colorHex
            && lhs.iconName == rhs.iconName
            && lhs.name == rhs.name
            && lhs.value == rhs.value
    }

    public var differenceIdentifier: String {
        id
    }

    public let id: String
    public let colorHex: String
    public let iconName: String
    public let name: String
    public let value: String?
    public let onSelect: PizzaEmptyClosure

    public var shouldDeselectImmediately: Bool {
        false
    }

    public init(id: String, colorHex: String, iconName: String, name: String, value: String?, onSelect: @escaping PizzaEmptyClosure) {
        self.id = id
        self.colorHex = colorHex
        self.iconName = iconName
        self.name = name
        self.value = value
        self.onSelect = onSelect
    }
}

public protocol PizzaFormSelectableItem {
    var onSelect: PizzaEmptyClosure { get }
    var shouldDeselectImmediately: Bool { get }
}

public protocol PizzaFormItem: Differentiable {
}

public struct PizzaFormEmptyHeaderSection: PizzaFormSection, Equatable {
    public static func == (lhs: PizzaFormEmptyHeaderSection, rhs: PizzaFormEmptyHeaderSection) -> Bool {
        return lhs.id == rhs.id
    }

    public var differenceIdentifier: String {
        return id
    }

    public let id: String
    public var items: [any PizzaFormItem]

    public init(id: String, items: [any PizzaFormItem]) {
        self.id = id
        self.items = items
    }
}

public protocol PizzaFormSection: Differentiable {
    var items: [any PizzaFormItem] { get }
}

public struct PizzaForm {
    public let sections: [any PizzaFormSection]
    public init(sections: [any PizzaFormSection]) {
        self.sections = sections
    }
}
