import UIKit
import PizzaKit

public class UIButtonStyle: UIStyle<UIButton> {

    public let title: String?
    public let backgroundColor: UIColor?
    public let size: PizzaButtonStylesSize
    public let alignment: PizzaButtonStylesAlignment
    public let type: PizzaButtonStylesType
    public let attributedTitleProvider: PizzaReturnClosure<String?, StringBuilder>

    public init(
        title: String?,
        backgroundColor: UIColor?,
        size: PizzaButtonStylesSize,
        alignment: PizzaButtonStylesAlignment,
        type: PizzaButtonStylesType,
        attributedTitleProvider: @escaping PizzaReturnClosure<String?, StringBuilder>
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.size = size
        self.alignment = alignment
        self.type = type
        self.attributedTitleProvider = attributedTitleProvider
    }

    public override func apply(for button: UIButton) {
        var configuration: UIButton.Configuration = {
            switch type {
            case .primary:
                return UIButton.Configuration.filled()
            case .secondary:
                return UIButton.Configuration.gray()
            case .tertiary:
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
            case .secondary:
                return nil
            case .tertiary:
                return nil
            }
        }()
        configuration.titleAlignment = {
            switch alignment {
            case .leading:
                return .leading
            case .center:
                return .center
            }
        }()
        configuration.baseForegroundColor = {
            switch type {
            case .primary:
                return .white
            case .secondary:
                return .label
            case .tertiary:
                return .tintColor
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

        button.configuration = configuration
    }

}
