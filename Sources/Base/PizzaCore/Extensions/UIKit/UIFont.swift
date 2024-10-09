import UIKit

public extension UIFont {

    /// Returns rounded font if possible
    var rounded: UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }

    /// Returns monospased font if possible
    var monospaced: UIFont {
        guard let descriptor = fontDescriptor.withDesign(.monospaced) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }

    /// Returns serif font if possible
    var serif: UIFont {
        guard let descriptor = fontDescriptor.withDesign(.serif) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }

}
