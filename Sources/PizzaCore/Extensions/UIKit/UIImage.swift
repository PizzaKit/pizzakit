import UIKit

public extension UIImage {

    /// Initialization for new image with given color and size
    convenience init(
        color: UIColor,
        size: CGSize
    ) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard
            let newCGImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        else {
            self.init()
            return
        }
        self.init(cgImage: newCGImage)
    }

    /// Method for returning image rendered with given alpha
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    /// Method for returning average color for current image
    func averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }
        let parameters = [
            kCIInputImageKey: ciImage,
            kCIInputExtentKey: CIVector(cgRect: ciImage.extent)
        ]
        guard
            let outputImage = CIFilter(
                name: "CIAreaAverage",
                parameters: parameters
            )?.outputImage
        else {
            return nil
        }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )
        return UIColor(
            red: CGFloat(bitmap[0]) / 255.0,
            green: CGFloat(bitmap[1]) / 255.0,
            blue: CGFloat(bitmap[2]) / 255.0,
            alpha: CGFloat(bitmap[3]) / 255.0
        )
    }

    /// Method for resizing image to given width
    func resizedImage(newWidth desiredWidth: CGFloat) -> UIImage {
        let oldWidth = size.width
        let scaleFactor = desiredWidth / oldWidth
        let newHeight = size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        return resizedImage(targetSize: newSize)
    }

    /// Method for resizing image to given height
    func resizedImage(newHeight desiredHeight: CGFloat) -> UIImage {
        let scaleFactor = desiredHeight / size.height
        let newWidth = size.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: desiredHeight)
        return resizedImage(targetSize: newSize)
    }

    /// Method for resizing image to given size
    func resizedImage(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    static func generateSettingsIcon(
        iconSystemName: String,
        iconColor: UIColor,
        iconFontSize: CGFloat,

        backgroundSystemName: String,
        backgroundColor: UIColor,
        backgroundFontSize: CGFloat
    ) -> UIImage? {
        // TODO: добавить кеширование - а то дергается на каждый чих
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: CGFloat(iconFontSize), weight: .regular)
        let iconImage = UIImage(systemName: iconSystemName, withConfiguration: iconConfiguration)?.withTintColor(iconColor, renderingMode: .alwaysOriginal)

        let backgroundConfiguration = UIImage.SymbolConfiguration(pointSize: CGFloat(backgroundFontSize), weight: .regular)
        let backgroundImage = UIImage(systemName: backgroundSystemName, withConfiguration: backgroundConfiguration)!.withTintColor(backgroundColor, renderingMode: .alwaysOriginal)

        let size = backgroundImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, .zero)

        backgroundImage.draw(in: CGRect(origin: .zero, size: size))

        if let iconImage = iconImage {
            let iconSize = iconImage.size
            iconImage.draw(in: CGRect(
                origin: .init(
                    x: (size.width - iconSize.width) / 2,
                    y: (size.height - iconSize.height) / 2
                ),
                size: iconSize
            ))
        }

        let settingsImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return settingsImage
    }

}
