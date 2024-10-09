import SFSafeSymbols
import PizzaCore
import UIKit

public struct PizzaCardPopupInfo {

    public enum ImageType {
        case customView(UIView)
        case image(UIImage)
        case sfSymbol(SFSymbol)
    }

    public enum ButtonType {
        case primary
        case secondary
    }

    public struct Button {
        public let id: String
        public let title: String
        public let type: ButtonType
        public let action: PizzaEmptyClosure?

        public init(
            id: String,
            title: String,
            type: ButtonType,
            action: PizzaEmptyClosure? = nil
        ) {
            self.id = id
            self.title = title
            self.type = type
            self.action = action
        }
    }

    public let image: ImageType?
    public let title: String?
    public let description: String?
    public let buttons: [Button]

    public init(
        image: ImageType?,
        title: String?,
        description: String?,
        buttons: [Button]
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.buttons = buttons
    }

}
