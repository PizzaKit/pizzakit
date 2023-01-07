import UIKit

public extension UIFeedbackGenerator {

    // MARK: - Nested Types

    /// Style for generated feedback (just wrapper around system types)
    enum Style {

        case light
        case medium
        case heavy

        case notificationError
        case notificationSuccess
        case notificationWarning

        case selectionChanged
    }

    /// Method for generating system defined feedback with provided `Style`
    /// (just wrapper around system calls)
    static func impactOccurred(_ style: Style) {
        switch style {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .notificationError:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(
                UINotificationFeedbackGenerator.FeedbackType.error
            )
        case .notificationSuccess:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(
                UINotificationFeedbackGenerator.FeedbackType.success
            )
        case .notificationWarning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(
                UINotificationFeedbackGenerator.FeedbackType.warning
            )
        case .selectionChanged:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
