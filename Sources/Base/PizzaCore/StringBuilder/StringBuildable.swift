import Foundation

public protocol StringBuildable {

    var string: String? { get }

    func build() -> NSAttributedString?

    func buildMutable() -> NSMutableAttributedString?

}
