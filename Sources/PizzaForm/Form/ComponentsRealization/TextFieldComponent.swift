import UIKit
import PizzaKit

public struct TextFieldComponent: IdentifiableComponent {

    public struct Style {
        public let font: UIFont
        public let textColor: UIColor
        public let placeholderColor: UIColor
        public let alignment: NSTextAlignment
        public let keyboardType: UIKeyboardType
        public let autocapitalizationType: UITextAutocapitalizationType
        public let autocorrectionType: UITextAutocorrectionType
        public let returnKeyType: UIReturnKeyType

        public init(
            font: UIFont,
            textColor: UIColor,
            placeholderColor: UIColor,
            alignment: NSTextAlignment,
            keyboardType: UIKeyboardType,
            autocapitalizationType: UITextAutocapitalizationType,
            autocorrectionType: UITextAutocorrectionType,
            returnKeyType: UIReturnKeyType
        ) {
            self.font = font
            self.textColor = textColor
            self.placeholderColor = placeholderColor
            self.alignment = alignment
            self.keyboardType = keyboardType
            self.autocapitalizationType = autocapitalizationType
            self.autocorrectionType = autocorrectionType
            self.returnKeyType = returnKeyType
        }

        public static let `default` = Style(
            font: .systemFont(ofSize: 17),
            textColor: .label,
            placeholderColor: .tertiaryLabel,
            alignment: .left,
            keyboardType: .default,
            autocapitalizationType: .sentences,
            autocorrectionType: .default,
            returnKeyType: .default
        )

        public static let defaultEmail = Style(
            font: .systemFont(ofSize: 17),
            textColor: .label,
            placeholderColor: .tertiaryLabel,
            alignment: .left,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
    }

    public let id: String
    public let placeholder: String?
    public let text: String?
    public let style: Style
    public let onTextChanged: PizzaClosure<String?>?
    public let onTextBeginEditing: PizzaEmptyClosure?
    public let onTextEndEditing: PizzaEmptyClosure?

    /// return true to endEditing, false to skip
    public let shouldReturnKey: PizzaEmptyReturnClosure<Bool>?

    public init(
        id: String,
        placeholder: String? = nil,
        text: String? = nil,
        style: Style = .default,
        onTextChanged: PizzaClosure<String?>? = nil,
        onTextBeginEditing: PizzaEmptyClosure? = nil,
        onTextEndEditing: PizzaEmptyClosure? = nil,
        shouldReturnKey: PizzaEmptyReturnClosure<Bool>? = nil
    ) {
        self.id = id
        self.placeholder = placeholder
        self.text = text
        self.style = style
        self.onTextChanged = onTextChanged
        self.onTextBeginEditing = onTextBeginEditing
        self.onTextEndEditing = onTextEndEditing
        self.shouldReturnKey = shouldReturnKey
    }

    public func createRenderTarget() -> TextFieldComponentView {
        return TextFieldComponentView()
    }

    public func render(
        in renderTarget: TextFieldComponentView,
        renderType: RenderType
    ) {
        renderTarget.configure(
            placeholder: placeholder,
            text: text,
            style: style,
            onTextChanged: onTextChanged,
            onTextBeginEditing: onTextBeginEditing,
            onTextEndEditing: onTextEndEditing,
            shouldReturnKey: shouldReturnKey
        )
    }

}

public class TextFieldComponentView: PizzaView, UITextFieldDelegate {

    private let textField = UITextField()

    private var onTextChanged: PizzaClosure<String?>?
    private var onTextBeginEditing: PizzaEmptyClosure?
    private var onTextEndEditing: PizzaEmptyClosure?
    private var shouldReturnKey: PizzaEmptyReturnClosure<Bool>?

    public override func commonInit() {
        super.commonInit()

        textField.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make
                    .edges
                    .equalToSuperview()
                    .inset(UIEdgeInsets(horizontal: 0, vertical: 12))
            }
            $0.delegate = self
            $0.addTarget(
                self,
                action: #selector(handleTextFieldValueChanged(sender:)),
                for: .editingChanged
            )
        }
    }

    public func configure(
        placeholder: String?,
        text: String?,
        style: TextFieldComponent.Style,
        onTextChanged: PizzaClosure<String?>?,
        onTextBeginEditing: PizzaEmptyClosure?,
        onTextEndEditing: PizzaEmptyClosure?,
        shouldReturnKey: PizzaEmptyReturnClosure<Bool>?
    ) {
        if textField.text != text {
            textField.text = text
        }
        textField.font = style.font
        textField.keyboardType = style.keyboardType
        textField.autocapitalizationType = style.autocapitalizationType
        textField.autocorrectionType = style.autocorrectionType
        textField.returnKeyType = .done
        textField.textColor = style.textColor
        textField.textAlignment = style.alignment
        if let placeholder {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = style.alignment
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .font: style.font,
                    .foregroundColor: style.placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
            )
        } else {
            textField.placeholder = nil
        }
        self.onTextChanged = onTextChanged
        self.onTextBeginEditing = onTextBeginEditing
        self.onTextEndEditing = onTextEndEditing
        self.shouldReturnKey = shouldReturnKey
    }

    @objc
    private func handleTextFieldValueChanged(sender: UITextField) {
        onTextChanged?(sender.text)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        onTextEndEditing?()
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        onTextBeginEditing?()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shouldReturnKey?() == true {
            textField.resignFirstResponder()
            return true
        }
        return false
    }

}
