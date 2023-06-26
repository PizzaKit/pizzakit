import PizzaCore
import Foundation
import Combine
import UIKit
import Defaults
import WidgetKit

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

    public var valuePublisher: AnyPublisher<PizzaAppTheme, Never> {
        valueSubject.eraseToAnyPublisher()
    }
    public var value: PizzaAppTheme {
        get {
            Defaults[.appThemeKey(userDefaults: userDefaults)]
        }
        set {
            valueSubject.send(newValue)
        }
    }

    private let valueSubject = PassthroughSubject<PizzaAppTheme, Never>()
    private var bag = Set<AnyCancellable>()

    private let userDefaults: UserDefaults

    // MARK: - Initalization

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        valueSubject
            .sink { [weak self] newTheme in
                guard let self else { return }
                Defaults[.appThemeKey(userDefaults: self.userDefaults)] = newTheme

                self.userDefaults.synchronize()
                WidgetCenter.shared.reloadAllTimelines()
            }
            .store(in: &bag)
    }

}

fileprivate extension Defaults.Keys {

    static func appThemeKey(userDefaults: UserDefaults) -> Defaults.Key<PizzaAppTheme> {
        Defaults.Key<PizzaAppTheme>(
            "app_theme",
            default: .default,
            suite: userDefaults
        )
    }

}
