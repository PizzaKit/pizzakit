import UIKit
import PizzaCore
import SnapKit

public struct EmptyHeightComponent: Component {

    public let height: CGFloat

    public init(height: CGFloat) {
        self.height = height
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

    public func render(in renderTarget: UIView, renderType: RenderType) {}

}
