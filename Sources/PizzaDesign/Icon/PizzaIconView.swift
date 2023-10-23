import SFSafeSymbols
import UIKit
import SnapKit
import PizzaCore
import SwiftUI

private class PizzaIconBackgroundView: PizzaView {

    var shape: PizzaIcon.Shape? {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    var background: PizzaIcon.Background? {
        didSet {
            updateColors()
        }
    }
    var foregroundColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    override func commonInit() {
        super.commonInit()

        layer.masksToBounds = true
        layer.cornerCurve = .continuous
        updateColors()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        switch shape {
        case .square, .none:
            layer.cornerRadius = 0
        case .circle:
            layer.cornerRadius = bounds.height / 2
        case .roundedSquare(let shapeRoundedSquareRoundType):
            switch shapeRoundedSquareRoundType {
            case .fixed(let fixed):
                layer.cornerRadius = fixed
            case .percentage(let percentage):
                layer.cornerRadius = bounds.height * percentage
            }
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        updateColors()
    }

    private func updateColors() {
        switch background {
        case .transparent, .none:
            backgroundColor = .clear
            alpha = 1
        case .dimmedForeground(let alpha):
            backgroundColor = foregroundColor
            self.alpha = alpha
        case .colored(let color):
            backgroundColor = color
            alpha = 1
        }
    }

}

public struct PizzaSUIIconView: UIViewRepresentable {

    let icon: PizzaIcon
    let shouldBounce: Bool

    public init(icon: PizzaIcon, shouldBounce: Bool) {
        self.icon = icon
        self.shouldBounce = shouldBounce
    }

    public func makeUIView(context: Context) -> PizzaIconView {
        PizzaIconView()
    }

    public func updateUIView(_ uiView: PizzaIconView, context: Context) {
        uiView.configure(icon: icon, shouldBounce: shouldBounce)
    }

}

public class PizzaIconView: PizzaView {

    private let imageView = UIImageView()
    private let backgroundView = PizzaIconBackgroundView()

    public override func commonInit() {
        super.commonInit()

        backgroundView.do { v in
            addSubview(v)
            v.snp.makeConstraints { make in
                make.edges.equalToSuperview().priority(.high)
            }

            v.snp.makeConstraints { make in
                make.width.equalTo(v.snp.height)
                make.width.equalTo(10)
            }
        }

        imageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.bottom.lessThanOrEqualToSuperview()
                    .priority(.high)
                make.center.equalToSuperview()
            }
            $0.contentMode = .center
        }
    }

    public func configure(icon: PizzaIcon, shouldBounce: Bool) {
        switch icon.representation {
        case .image(let image):
            imageView.image = image
            imageView.tintColor = icon.foreground.color
            imageView.isHidden = false
        case .sfSymbol(let symbol):
            imageView.image = UIImage(
                systemSymbol: symbol,
                withConfiguration: {
                    var conf: UIImage.SymbolConfiguration?

                    func applyOrCreate(other: UIImage.SymbolConfiguration) {
                        if conf == nil {
                            conf = other
                        } else {
                            conf = conf?.applying(other)
                        }
                    }

//                    if let size = icon.size {
                        applyOrCreate(
                            other: UIImage.SymbolConfiguration(pointSize: icon.size.iconPointSize)
                        )
//                    }

                    if case .hierarchical(let color) = icon.foreground {
                        applyOrCreate(
                            other: UIImage.SymbolConfiguration(
                                hierarchicalColor: color
                            )
                        )
                    }

                    if case .palette(let colors) = icon.foreground {
                        applyOrCreate(
                            other: UIImage.SymbolConfiguration(
                                paletteColors: colors
                            )
                        )
                    }

                    return conf
                }()
            )
            imageView.tintColor = icon.foreground.color
            imageView.isHidden = false
        case .none:
            imageView.isHidden = true
        }

        backgroundView.shape = icon.shape
        backgroundView.background = icon.background
        backgroundView.foregroundColor = icon.foreground.color
//        if let size = icon.size {
//
//        }
        backgroundView.snp.updateConstraints { make in
            make.width.equalTo(icon.size.pointSize)
        }

        if #available(iOS 17.0, *) {
            if shouldBounce {
                imageView.addSymbolEffect(.bounce.up.byLayer)
                onTap(completion: { [weak self] in
                    self?.imageView.addSymbolEffect(.bounce.up.byLayer)
                })
            } else {
                imageView.removeAllSymbolEffects()
                onTap(completion: nil)
            }
        } else {
            onTap(completion: nil)
        }
    }

}
