import UIKit
import PizzaCore
import SnapKit

public enum EmptyHeightComponentBackgroundType {
    case `default`
    case withoutBackground
}


public struct EmptyHeightIdentifiableComponent: IdentifiableComponent {

    public let id: String
    public let height: CGFloat
    public let backgroundType: EmptyHeightComponentBackgroundType

    public init(
        id: String,
        height: CGFloat,
        backgroundType: EmptyHeightComponentBackgroundType = .default
    ) {
        self.id = id
        self.height = height
        self.backgroundType = backgroundType
    }

    public func createRenderTarget() -> UIView {
        return UIView()
    }

    public func layout(renderTarget: UIView, in container: UIView) {
        renderTarget.do {
            container.addSubview($0)
            $0.snp.makeConstraints { make in
                make
                    .leading
                    .top
                    .equalToSuperview()
                make
                    .trailing
                    .bottom
                    .equalToSuperview()
                    .priority(999)
                make
                    .height
                    .equalTo(height)
            }
        }
    }

    public func render(in renderTarget: UIView, renderType: RenderType) {
        switch backgroundType {
        case .default:
            break
        case .withoutBackground:
            let tableCell: UITableViewCell? = renderTarget.traverseAndFindClass()
            tableCell?.backgroundColor = .clear

            let collectionCell: UICollectionViewCell? = renderTarget.traverseAndFindClass()
            collectionCell?.backgroundColor = .clear
        }
    }

}

public struct EmptyHeightComponent: Component {

    public let height: CGFloat
    public let backgroundType: EmptyHeightComponentBackgroundType

    public init(
        height: CGFloat,
        backgroundType: EmptyHeightComponentBackgroundType = .default
    ) {
        self.height = height
        self.backgroundType = backgroundType
    }

    public func createRenderTarget() -> UIView {
        return UIView()
    }

    public func layout(renderTarget: UIView, in container: UIView) {
        renderTarget.do {
            container.addSubview($0)
            $0.snp.makeConstraints { make in
                make
                    .leading
                    .top
                    .equalToSuperview()
                make
                    .trailing
                    .bottom
                    .equalToSuperview()
                    .priority(999)
                make
                    .height
                    .equalTo(height)
            }
        }
    }

    public func render(in renderTarget: UIView, renderType: RenderType) {
        switch backgroundType {
        case .default:
            break
        case .withoutBackground:
            let tableCell: UITableViewCell? = renderTarget.traverseAndFindClass()
            tableCell?.backgroundColor = .clear

            let collectionCell: UICollectionViewCell? = renderTarget.traverseAndFindClass()
            collectionCell?.backgroundColor = .clear
        }
    }

}
