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

public protocol PizzaAppThemeService {
    var valuePublisher: PizzaRWPublisher<PizzaAppTheme, Never> { get }
}

public class PizzaAppThemeServiceImpl: PizzaAppThemeService {

    // MARK: - PizzaAppThemeService

    public lazy var valuePublisher: PizzaRWPublisher<PizzaAppTheme, Never> = PizzaPassthroughRWPublisher<PizzaAppTheme, Never>(
        currentValue: {
            Defaults[.appThemeKey(userDefaults: self.userDefaults)]
        },
        onValueChanged: { [weak self] newValue in
            guard let self else { return }
            Defaults[.appThemeKey(userDefaults: self.userDefaults)] = newValue

            self.userDefaults.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
        }
    )

    // MARK: - Properties

    private let userDefaults: UserDefaults

    // MARK: - Initalization

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
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
