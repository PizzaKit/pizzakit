import PizzaCore
import Foundation
import Combine
import UIKit
import Defaults

public struct PizzaAppTheme: Codable, Defaults.Serializable {

    public enum ThemeType: String, Codable, Defaults.Serializable {
        case automatic
        case light
        case dark
    }

    public var tintColorIndex: Int
    public var themeType: ThemeType

    public static var allTintColors: [UIColor]!
    public static var defaultTintColorIndex: Int!

    public var tintColor: UIColor {
        PizzaAppTheme.allTintColors[safe: tintColorIndex % PizzaAppTheme.allTintColors.count] ?? .systemBlue
    }

    public static var `default`: PizzaAppTheme {
        .init(
            tintColorIndex: defaultTintColorIndex,
            themeType: .automatic
        )
    }
}

public class PizzaAppThemeService {

    // MARK: - Properties

    public var valueSubject: AnyPublisher<PizzaAppTheme, Never> {
        currentValueSubject.eraseToAnyPublisher()
    }
    public var value: PizzaAppTheme {
        get {
            currentValueSubject.value
        }
        set {
            currentValueSubject.send(newValue)
        }
    }

    private let currentValueSubject: CurrentValueSubject<PizzaAppTheme, Never>
    private var bag = Set<AnyCancellable>()

    // MARK: - Initalization

    public init() {
        let appTheme = Defaults[.appTheme]
        currentValueSubject = .init(appTheme)

        currentValueSubject
            .dropFirst()
            .sink { newTheme in
                Defaults[.appTheme] = newTheme
            }
            .store(in: &bag)
    }

}

fileprivate extension Defaults.Keys {
    static let appTheme = Defaults.Key<PizzaAppTheme>("app_theme", default: .default)
}
