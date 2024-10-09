import UIKit

public extension UIColor {

    /// Initialization with light and dark colors
    convenience init(light: UIColor, dark: UIColor) {
        self.init(dynamicProvider: { trait in
            trait.userInterfaceStyle == .dark ? dark : light
        })
    }

    /// Initialization with hex color
    /// (could be provided with or without '#' and with or without alpha channel)
    convenience init(hex: String) {
        let hex = UIColor.parseHex(hex: hex, alpha: nil)
        self.init(red: hex.red, green: hex.green, blue: hex.blue, alpha: hex.alpha)
    }

    /// Initialization with hex color
    /// (could be provided with or without '#', alpha channel from hex will
    /// be ignored if exists)
    convenience init(hex: String, alpha: CGFloat) {
        let hex = UIColor.parseHex(hex: hex, alpha: alpha)
        self.init(red: hex.red, green: hex.green, blue: hex.blue, alpha: hex.alpha)
    }

    /// Property for getting/settings tintColor for all windows
    static var windowTint: UIColor {
        get {
            let value = UIApplication.allWindows.first?.tintColor
            guard let tint = value else { return .systemBlue }
            return tint
        }
        set {
            UIApplication.allWindows.forEach({ $0.tintColor = newValue })
        }
    }

    /// Property for getting hex string from current color
    var hex: String {
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a * 255)))
        }

        return color
    }

    /// Method for mixing current color with white color
    func lighter(by amount: CGFloat) -> UIColor {
        mixWithColor(UIColor.white, amount: amount)
    }

    /// Method for mixing current color with black color
    func darker(by amount: CGFloat) -> UIColor {
        mixWithColor(UIColor.black, amount: amount)
    }

    /// Method for mixing current color with provided color with given intencity
    func mixWithColor(_ color: UIColor, amount: CGFloat = 0.25) -> UIColor {
        var r1     : CGFloat = 0
        var g1     : CGFloat = 0
        var b1     : CGFloat = 0
        var alpha1 : CGFloat = 0
        var r2     : CGFloat = 0
        var g2     : CGFloat = 0
        var b2     : CGFloat = 0
        var alpha2 : CGFloat = 0

        self.getRed (&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor(
            red: r1 * (1.0 - amount) + r2 * amount,
            green: g1 * (1.0 - amount) + g2 * amount,
            blue: b1 * (1.0 - amount) + b2 * amount,
            alpha: alpha1)
    }

    // MARK: - Getters for custom system related colors

    static var systemColorfulColors: [UIColor] {
        if #available(iOS 15.0, *) {
            return [
                .systemRed,
                .systemOrange,
                .systemYellow,
                .systemGreen,
                .systemCyan,
                .systemBlue,
                .systemIndigo,
                .systemPink,
                .systemPurple,
                .systemBrown,
                .systemTeal,
                .systemMint
            ]
        } else {
            return [
                .systemRed,
                .systemOrange,
                .systemYellow,
                .systemGreen,
                .systemBlue,
                .systemIndigo,
                .systemPink,
                .systemPurple,
                .systemBrown,
                .systemTeal
            ]
        }
    }
    static var footnoteColor: UIColor {
        UIColor(light: UIColor(hex: "6D6D72"), dark: UIColor(hex: "8E8E93"))
    }
    static var destructiveColor: UIColor { .systemRed }
    static var warningColor: UIColor { .systemOrange }

    // MARK: - Private Methods

    /// Method for parsing hex color and returning color components
    private static func parseHex(
        hex: String,
        alpha: CGFloat?
    ) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var newAlpha: CGFloat = alpha ?? 1.0
        var hex:   String = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                if alpha == nil {
                    newAlpha = CGFloat(hexValue & 0x000F)      / 15.0
                }
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                if alpha == nil {
                    newAlpha = CGFloat(hexValue & 0x000000FF)  / 255.0
                }
            default:
                print("UIColorExtension - Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
            }
        } else {
            print("UIColorExtension - Scan hex error")
        }
        return (red, green, blue, newAlpha)
    }

}
