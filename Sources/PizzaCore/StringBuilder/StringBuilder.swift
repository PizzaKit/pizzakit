import UIKit

final public class StringBuilder: StringBuildable {

    // MARK: - Private Properties

    public private(set) var attributes: [NSAttributedString.Key: Any]

    // MARK: - Initialization

    public init(
        text: String? = nil,
        initialAttributes: [NSAttributedString.Key: Any] = [:]
    ) {
        self.string = text
        self.attributes = initialAttributes
    }

    // MARK: - StringBuildable

    public let string: String?

    public func build() -> NSAttributedString? {
        return buildMutable()
    }

    public func buildMutable() -> NSMutableAttributedString? {
        guard let string = string else { return nil }
        return NSMutableAttributedString(string: string, attributes: attributes)
    }

    // MARK: - Methods

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> StringBuilder {
        updateParagraphStyle { $0.alignment = alignment }

        return self
    }

    @discardableResult
    public func foregroundColor(_ color: UIColor) -> StringBuilder {
        attributes[.foregroundColor] = color

        return self
    }

    @discardableResult
    public func font(_ font: UIFont) -> StringBuilder {
        attributes[.font] = font

        return self
    }

    @discardableResult
    public func fontWeight(_ weight: UIFont.Weight) -> StringBuilder {
        if let font = attributes[.font] as? UIFont {
            return self.font(.systemFont(ofSize: font.pointSize, weight: weight))
        }

        return self
    }

    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> StringBuilder {
        updateParagraphStyle { $0.lineBreakMode = lineBreakMode }

        return self
    }

    @discardableResult
    public func lineHeight(_ lineHeight: CGFloat) -> StringBuilder {
        updateParagraphStyle {
            $0.minimumLineHeight = lineHeight
            $0.maximumLineHeight = lineHeight
        }

        return self
    }

    @discardableResult
    public func letterSpacing(_ kern: CGFloat) -> StringBuilder {
        attributes[.kern] = kern

        return self
    }

    // MARK: - Private Methods

    private func updateParagraphStyle(_ updateClosure: (NSMutableParagraphStyle) -> Void) {
        let paragraphStyle = (attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        updateClosure(paragraphStyle)
        attributes[.paragraphStyle] = paragraphStyle
    }

}
