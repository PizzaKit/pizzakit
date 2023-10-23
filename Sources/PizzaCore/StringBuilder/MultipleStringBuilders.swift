import UIKit

public class MultipleStringBuilders: StringBuildable {

    // MARK: - Private Properties

    private var builders: [StringBuilder]

    // MARK: - Initialization

    public init(builders: [StringBuilder] = []) {
        self.builders = builders
    }

    public init(builder: StringBuilder) {
        builders = [builder]
    }

    // MARK: - StringBuildable

    public var string: String? {
        var attributedStrings = builders.compactMap { $0.buildMutable() }
        guard let first = attributedStrings.first else { return nil }
        attributedStrings.removeFirst()

        var resultString = first.string
        for attributedString in attributedStrings {
            resultString += attributedString.string
        }

        return resultString
    }

    public func build() -> NSAttributedString? {
        return buildMutable()
    }

    public func buildMutable() -> NSMutableAttributedString? {
        var attributedStrings = builders.compactMap { $0.buildMutable() }
        guard let first = attributedStrings.first else { return nil }
        attributedStrings.removeFirst()
        attributedStrings.forEach(first.append)
        return first
    }

    // MARK: - Methods

    public func append(_ builder: StringBuilder) {
        builders.append(builder)
    }

    public func append(_ builders: [StringBuilder]) {
        self.builders.append(contentsOf: builders)
    }

}
