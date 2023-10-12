import UIKit
import SFSafeSymbols
import PizzaDesign

public enum ComponentIcon {

    public struct SystemSquareRounded {

        public enum RenderingMode {
            case hierarchical
            case oneColor
        }

        public let sfSymbol: SFSymbol
        public let tintColor: UIColor
        public let backgroundColor: UIColor?
        public let renderingMode: RenderingMode

        public init(
            sfSymbol: SFSymbol,
            tintColor: UIColor = .white,
            backgroundColor: UIColor? = nil,
            renderingMode: RenderingMode = .oneColor
        ) {
            self.sfSymbol = sfSymbol
            self.tintColor = tintColor
            self.backgroundColor = backgroundColor
            self.renderingMode = renderingMode
        }
    }

    case systemSquareRounded(SystemSquareRounded)
    case background(color: UIColor)
    case custom(UIImage)

}

public class ComponentSystemIconView: PizzaView {

    private let backgroundImageView = UIImageView()
    private let foregroundImageView = UIImageView()

    public override func commonInit() {
        super.commonInit()

        backgroundImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            $0.contentMode = .center
        }

        foregroundImageView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            $0.contentMode = .center
        }
    }

    public func configure(
        sfSymbol: SFSymbol?,
        tintColor: UIColor?,
        backgroundColor: UIColor?,
        renderingMode: ComponentIcon.SystemSquareRounded.RenderingMode?
    ) {
        if let sfSymbol {
            foregroundImageView.image = UIImage(
                systemName: sfSymbol.rawValue,
                withConfiguration: {
                    var conf = UIImage.SymbolConfiguration(
                        pointSize: backgroundColor == nil ? 22 : 16
                    )

                    if 
                        let renderingMode,
                        renderingMode == .hierarchical,
                        let tintColor
                    {
                        conf = conf.applying(
                            UIImage.SymbolConfiguration(
                                hierarchicalColor: tintColor
                            )
                        )
                    }

                    return conf
                }()
            )
            foregroundImageView.tintColor = tintColor
        }
        foregroundImageView.isHidden = sfSymbol == nil

        backgroundImageView.isHidden = backgroundColor == nil
        backgroundImageView.image = UIImage(
            systemName: "app.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)
        )
        backgroundImageView.tintColor = backgroundColor
    }

}

public class ComponentIconView: PizzaView {

    private let systemIconView = ComponentSystemIconView()
    private let imageView = UIImageView()

    public override func commonInit() {
        super.commonInit()

        systemIconView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        imageView.do {
            addSubview($0)
            $0.contentMode = .scaleAspectFill
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    public func configure(icon: ComponentIcon) {
        switch icon {
        case .custom(let uIImage):
            imageView.image = uIImage

            systemIconView.isHidden = true
            imageView.isHidden = false
        case .systemSquareRounded(let payload):
            systemIconView.configure(
                sfSymbol: payload.sfSymbol,
                tintColor: payload.tintColor,
                backgroundColor: payload.backgroundColor,
                renderingMode: payload.renderingMode
            )
            systemIconView.isHidden = false
            imageView.isHidden = true
        case .background(let backgroundColor):
            systemIconView.configure(
                sfSymbol: nil,
                tintColor: nil,
                backgroundColor: backgroundColor,
                renderingMode: nil
            )
            systemIconView.isHidden = false
            imageView.isHidden = true
        }
    }
    
}
