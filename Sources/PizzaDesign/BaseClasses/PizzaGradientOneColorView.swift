import PizzaCore
import UIKit

/// Градиент одним цветом. Состоит из двух цветов
/// 1. заданный в `gradientColor`
/// 2. осветленный/затемненный цвет из `gradientColor` (в зависимости от темы)
public class PizzaGradientOneColorView: PizzaView {

    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    public var gradientColor: UIColor = .tintColor {
        didSet {
            updateGradientColors()
        }
    }

    public override func commonInit() {
        super.commonInit()

        gradientLayer.do {
            $0.startPoint = .zero
            $0.endPoint = .init(x: 0, y: 1)
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGradientColors()
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        updateGradientColors()
    }

    private func updateGradientColors() {
        if traitCollection.userInterfaceStyle == .light {
            gradientLayer.colors = [
                gradientColor.mixWithColor(.systemBackground, amount: 0.2).cgColor,
                gradientColor.cgColor
            ]
        } else {
            gradientLayer.colors = [
                gradientColor.cgColor,
                gradientColor.mixWithColor(.systemBackground, amount: 0.2).cgColor
            ]
        }

    }

}
