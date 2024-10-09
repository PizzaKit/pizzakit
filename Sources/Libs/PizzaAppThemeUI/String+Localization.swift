import Foundation

extension String {

    static func localized(key: String) -> String {
        return NSLocalizedString(key, bundle: .module, comment: "")
    }

}
