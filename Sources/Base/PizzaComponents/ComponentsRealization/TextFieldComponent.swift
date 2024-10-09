import UIKit
import PizzaDesign
import PizzaCore

public struct TextFieldComponent: IdentifiableComponent {

    public let id: String
    public let text: String?
    public let style: UIStyle<UITextField>
    public let onTextChanged: PizzaClosure<String?>?
    public let onTextBeginEditing: PizzaEmptyClosure?
    public let onTextEndEditing: PizzaEmptyClosure?

    /// return true to endEditing, false to skip
    public let shouldReturnKey: PizzaEmptyReturnClosure<Bool>?

    public init(
        id: String,
        text: String? = nil,
        style: UIStyle<UITextField>,
        onTextChanged: PizzaClosure<String?>? = nil,
        onTextBeginEditing: PizzaEmptyClosure? = nil,
        onTextEndEditing: PizzaEmptyClosure? = nil,
        shouldReturnKey: PizzaEmptyReturnClosure<Bool>? = nil
    ) {
        self.id = id
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
        text: String?,
        style: UIStyle<UITextField>,
        onTextChanged: PizzaClosure<String?>?,
        onTextBeginEditing: PizzaEmptyClosure?,
        onTextEndEditing: PizzaEmptyClosure?,
        shouldReturnKey: PizzaEmptyReturnClosure<Bool>?
    ) {
        if textField.text != text {
            textField.text = text
        }
        style.apply(for: textField)
        
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
