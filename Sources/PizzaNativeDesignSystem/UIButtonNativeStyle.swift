import UIKit
import PizzaKit
import SFSafeSymbols

public class UIButtonStyle: UIStyle<UIButton> {

    public struct Icon {
        public let symbol: SFSymbol
        public let position: IconPosition
        public let size: CGFloat

        public init(
            symbol: SFSymbol, 
            position: IconPosition, 
            size: CGFloat
        ) {
            self.symbol = symbol
            self.position = position
            self.size = size
        }
    }

    public enum IconPosition {
        case leading
        case trailing
    }

    public let title: String?
    public let backgroundColor: UIColor?
    public let size: PizzaButtonStylesSize
    public let type: PizzaButtonStylesType
    public let attributedTitleProvider: PizzaReturnClosure<String?, StringBuilder>
    public let isLoading: Bool
    public let imagePadding: CGFloat
    public let icon: Icon?

    public init(
        title: String?,
        backgroundColor: UIColor?,
        size: PizzaButtonStylesSize,
        type: PizzaButtonStylesType,
        attributedTitleProvider: @escaping PizzaReturnClosure<String?, StringBuilder>,
        isLoading: Bool = false,
        imagePadding: CGFloat = 0,
        icon: Icon? = nil
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.size = size
        self.type = type
        self.attributedTitleProvider = attributedTitleProvider
        self.isLoading = isLoading
        self.imagePadding = imagePadding
        self.icon = icon
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
            case .custom:
                return .fixed
            }
        }()
        configuration.buttonSize = {
            switch size {
            case .large, .custom:
                return .large
            case .medium:
                return .medium
            case .small:
                return .small
            }
        }()
        configuration.showsActivityIndicator = isLoading
        configuration.imagePadding = imagePadding
        configuration.image = icon.map {
            UIImage(
                systemSymbol: $0.symbol,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: $0.size)
            )
        }
        configuration.imagePlacement = {
            switch icon?.position {
            case .leading, .none:
                return .leading
            case .trailing:
                return .trailing
            }
        }()
        if case .custom(let contentInsets) = size {
            configuration.contentInsets = contentInsets
        }

        button.configuration = configuration
    }

}

public extension NSDirectionalEdgeInsets {

    static var defaultButtonContentInsets: NSDirectionalEdgeInsets {
        .init(horizontal: 10, vertical: 4)
    }

}
