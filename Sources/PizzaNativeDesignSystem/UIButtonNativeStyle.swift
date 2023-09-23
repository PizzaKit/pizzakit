import UIKit
import PizzaKit

public class UIButtonStyle: UIStyle<UIButton> {

    public let title: String?
    public let backgroundColor: UIColor?
    public let size: PizzaButtonStylesSize
    public let type: PizzaButtonStylesType
    public let attributedTitleProvider: PizzaReturnClosure<String?, StringBuilder>
    public let isLoading: Bool

    public init(
        title: String?,
        backgroundColor: UIColor?,
        size: PizzaButtonStylesSize,
        type: PizzaButtonStylesType,
        attributedTitleProvider: @escaping PizzaReturnClosure<String?, StringBuilder>,
        isLoading: Bool
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.size = size
        self.type = type
        self.attributedTitleProvider = attributedTitleProvider
        self.isLoading = isLoading
    }

    public override func apply(for button: UIButton) {
        var configuration: UIButton.Configuration = {
            switch type {
            case .primary, .error:
                return UIButton.Configuration.filled()
            case .secondary:
                return UIButton.Configuration.gray()
            case .tertiary, .errorTertiary:
                return UIButton.Configuration.plain()
            }
        }()
        configuration.attributedTitle = attributedTitleProvider(title)
            .build()
            .map { AttributedString($0) }
        configuration.baseBackgroundColor = {
            switch type {
            case .primary:
                return backgroundColor
            case .secondary, .tertiary, .errorTertiary:
                return nil
            case .error:
                return .systemRed
            }
        }()
        configuration.baseForegroundColor = {
            switch type {
            case .primary, .error:
                return .white
            case .secondary:
                return .label
            case .tertiary:
                return .tintColor
            case .errorTertiary:
                return .systemRed
            }
        }()
        configuration.cornerStyle = {
            switch size {
            case .large:
                return .large
            case .medium:
                return .medium
            case .small:
                return .small
            }
        }()
        configuration.buttonSize = {
            switch size {
            case .large:
                return .large
            case .medium:
                return .medium
            case .small:
                return .small
            }
        }()
        configuration.showsActivityIndicator = isLoading

        button.configuration = configuration
    }

}
