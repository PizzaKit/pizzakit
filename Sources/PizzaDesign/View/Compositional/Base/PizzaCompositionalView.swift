import UIKit
import PizzaCore

public extension Pizza.Compositional {
    typealias View = PizzaCompositionalView
}

/// View that consists of blocks
open class PizzaCompositionalView: PizzaView {

    // MARK: - Private Properties

    private let subblocks: [PizzaCompositionalBlock]

    // MARK: - Initialization

    public init(
        @PizzaCompositionalBuilder subblocks: () -> [PizzaCompositionalBlock]
    ) {
        self.subblocks = subblocks()
        super.init(frame: .zero)

        self.subblocks.forEach {
            $0.onNeedRelayout = { [weak self] in
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
        }
    }

    open override func commonInit() {
        super.commonInit()
        subblocks.forEach { $0.initialize(parent: self) }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    open override func layoutSubviews() {
        super.layoutSubviews()
        subblocks.forEach { $0.layoutSubviews(parent: self) }
    }

    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        subblocks.forEach { $0.layoutSublayers(parent: self) }
    }

}
