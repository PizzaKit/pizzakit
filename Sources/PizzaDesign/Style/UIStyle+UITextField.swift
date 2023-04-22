import UIKit

public extension UIStyle where Control == UITextField {
    static func body(
        alignment: NSTextAlignment,
        placeholder: String?
    ) -> UITextFieldStyle {
        .init(
            font: .systemFont(ofSize: 17),
            textColor: .palette.labelColor,
            placeholderColor: .palette.labelTertiaryColor,
            placeholder: placeholder,
            alignment: alignment,
            keyboardType: .default,
            autocapitalizationType: .sentences,
            autocorrectionType: .default,
            returnKeyType: .default
        )
    }

    static func bodyEmail(
        alignment: NSTextAlignment,
        placeholder: String?
    ) -> UITextFieldStyle {
        .init(
            font: .systemFont(ofSize: 17),
            textColor: .palette.labelColor,
            placeholderColor: .palette.labelTertiaryColor,
            placeholder: placeholder,
            alignment: alignment,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
    }

    static func bodyError(
        alignment: NSTextAlignment,
        placeholder: String?
    ) -> UITextFieldStyle {
        .init(
            font: .systemFont(ofSize: 17),
            textColor: .palette.labelErrorColor,
            placeholderColor: .palette.labelTertiaryColor,
            placeholder: placeholder,
            alignment: alignment,
            keyboardType: .default,
            autocapitalizationType: .sentences,
            autocorrectionType: .default,
            returnKeyType: .default
        )
    }

    static func bodyEmailError(
        alignment: NSTextAlignment,
        placeholder: String?
    ) -> UITextFieldStyle {
        .init(
            font: .systemFont(ofSize: 17),
            textColor: .palette.labelErrorColor,
            placeholderColor: .palette.labelTertiaryColor,
            placeholder: placeholder,
            alignment: alignment,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
    }
}

public class UITextFieldStyle: UIStyle<UITextField> {

    public let font: UIFont
    public let textColor: UIColor
    public let placeholderColor: UIColor
    public let placeholder: String?
    public let alignment: NSTextAlignment
    public let keyboardType: UIKeyboardType
    public let autocapitalizationType: UITextAutocapitalizationType
    public let autocorrectionType: UITextAutocorrectionType
    public let returnKeyType: UIReturnKeyType

    init(
        font: UIFont, 
        textColor: UIColor, 
        placeholderColor: UIColor,
        placeholder: String?,
        alignment: NSTextAlignment, 
        keyboardType: UIKeyboardType, 
        autocapitalizationType: UITextAutocapitalizationType, 
        autocorrectionType: UITextAutocorrectionType, 
        returnKeyType: UIReturnKeyType
    ) {
        self.font = font
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.placeholder = placeholder
        self.alignment = alignment
        self.keyboardType = keyboardType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.returnKeyType = returnKeyType
    }

    public override func apply(for textField: UITextField) {
        textField.font = font
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType
        textField.returnKeyType = returnKeyType
        textField.textColor = textColor
        textField.textAlignment = alignment

        if let placeholder {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .font: font,
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
            )
        } else {
            textField.placeholder = nil
        }
    }
}
