import UIKit
import PizzaKit

public class UITextFieldNativeStyle: UIStyle<UITextField> {

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
        textField.font = font.roundedIfNeeded
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType
        textField.returnKeyType = returnKeyType
        textField.textColor = textColor
        textField.textAlignment = alignment

        if let placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .font: font,
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: NSMutableParagraphStyle().do {
                        $0.alignment = alignment
                    }
                ]
            )
        } else {
            textField.placeholder = nil
        }
    }
}
