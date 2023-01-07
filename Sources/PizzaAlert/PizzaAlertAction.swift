import Foundation
import PizzaCore

/// Action for alert
open class PizzaAlertAction {

    // MARK: - Nested types

    public enum Style {
        case cancel
        case destructive
        case `default`
    }

    // MARK: - Properties

    let title: String
    let handler: PizzaEmptyClosure?
    let style: Style
    private(set) var isPreferred: Bool

    // MARK: - Initialization

    public init(
        title: String,
        style: Style = .default,
        handler: PizzaEmptyClosure? = nil,
        isPreferred: Bool = false
    ) {
        self.title = title
        self.style = style
        self.handler = handler
        self.isPreferred = isPreferred
    }

    // MARK: - Public methods

    @discardableResult
    public func setPreferred() -> PizzaAlertAction {
        isPreferred = true
        return self
    }

    // MARK: - Static Properties

    public static func `default`(
        title: String,
        handler: PizzaEmptyClosure? = nil
    ) -> PizzaAlertAction {
        .init(
            title: title,
            style: .default,
            handler: handler
        )
    }

    public static func cancel(
        title: String = PizzaAlertConfiguration.defaultCancelText,
        handler: PizzaEmptyClosure? = nil
    ) -> PizzaAlertAction {
        .init(
            title: title,
            style: .cancel,
            handler: handler
        )
    }

    public static func destructive(
        title: String,
        handler: PizzaEmptyClosure? = nil
    ) -> PizzaAlertAction {
        .init(
            title: title,
            style: .destructive,
            handler: handler
        )
    }

}
