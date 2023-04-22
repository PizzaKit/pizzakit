import UIKit
import SFSafeSymbols
import PizzaDesign

public enum ComponentIcon {

    public struct System {
        public let sfSymbol: SFSymbol?
        public let backgroundColor: UIColor

        public init(sfSymbol: SFSymbol?, backgroundColor: UIColor) {
            self.sfSymbol = sfSymbol
            self.backgroundColor = backgroundColor
        }
    }

    case custom(UIImage)
    case system(System)

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
        systemIcon: ComponentIcon.System
    ) {
        if let sfSymbol = systemIcon.sfSymbol {
            foregroundImageView.image = UIImage(
                systemName: sfSymbol.rawValue,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)
            )
            foregroundImageView.tintColor = .white
        }
        foregroundImageView.isHidden = systemIcon.sfSymbol == nil

        backgroundImageView.image = UIImage(
            systemName: "app.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)
        )
        backgroundImageView.tintColor = systemIcon.backgroundColor
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

    public func configure(
        icon: ComponentIcon
    ) {
        switch icon {
        case .custom(let uIImage):
            imageView.image = uIImage

            systemIconView.isHidden = true
            imageView.isHidden = false
        case .system(let system):
            systemIconView.configure(systemIcon: system)

            systemIconView.isHidden = false
            imageView.isHidden = true
        }
    }
    
}
