import UIKit
import MobileCoreServices

public extension String {

    // MARK: - Constants

    static var empty: String { return "" }
    static var space: String { return " " }
    static var dot: String { return "." }
    static var newline: String { return "\n" }

    // MARK: - Different types

    var url: URL? {
        return URL(string: self)
    }
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    // MARK: - Other

    /// Trimmed string
    var trim: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Returns optional nil if string is empty
    var nilIfEmpty: String? {
        return self.isEmpty ? nil : self
    }

    var uppercasedFirstLetter: String {
        let lowercaseSctring = self.lowercased()
        return lowercaseSctring.prefix(1).uppercased() + lowercaseSctring.dropFirst()
    }

    // Method for removing prefix if exists (otherwise return same string)
    func removedPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return String(dropFirst(prefix.count))
        }
        return self
    }

    // Method for removing suffix if exists (otherwise return same string)
    func removedSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return String(dropLast(suffix.count))
        }
        return self
    }

    /// Method for calculating height of string
    func height(
        withConstrainedWidth width: CGFloat,
        font: UIFont
    ) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }

    /// Method for calculating width of string
    func width(
        withConstrainedHeight height: CGFloat,
        font: UIFont
    ) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.width)
    }

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    public struct SplitItem: Equatable {
        public let string: String
        public let isInside: Bool

        public init(string: String, isInside: Bool) {
            self.string = string
            self.isInside = isInside
        }
    }

    public func split(symbol: Character) -> [SplitItem] {
        var isInside = false
        var result: [SplitItem] = []
        var currentString = ""
        for char in self {
            if char == symbol {
                result.append(
                    .init(
                        string: currentString,
                        isInside: isInside
                    )
                )
                currentString = ""
                isInside.toggle()
            } else {
                currentString.append(char)
            }
        }
        result.append(
            .init(
                string: currentString,
                isInside: isInside
            )
        )

        return result.filter {
            $0.string.nilIfEmpty != nil
        }
    }

}
