import UIKit
import SPIndicator

public enum PizzaIndicator {

    @MainActor
    public static func present(
        title: String,
        message: String? = nil,
        haptic: SPIndicatorHaptic,
        from presentSide: SPIndicatorPresentSide = .top,
        completion: (() -> Void)? = nil
    ) {
        SPIndicator.present(
            title: title,
            message: message,
            haptic: haptic,
            from: presentSide,
            completion: completion
        )
    }

    @MainActor
    public static func present(
        title: String,
        message: String? = nil,
        preset: SPIndicatorIconPreset,
        from presentSide: SPIndicatorPresentSide = .top,
        completion: (() -> Void)? = nil
    ) {
        SPIndicator.present(
            title: title,
            message: message,
            preset: preset,
            from: presentSide,
            completion: completion
        )
    }

    @MainActor
    public static func present(
        title: String,
        message: String? = nil,
        preset: SPIndicatorIconPreset,
        haptic: SPIndicatorHaptic,
        from presentSide: SPIndicatorPresentSide = .top,
        completion: (() -> Void)? = nil
    ) {
        SPIndicator.present(
            title: title,
            message: message,
            preset: preset,
            haptic: haptic,
            from: presentSide,
            completion: completion
        )
    }

}
