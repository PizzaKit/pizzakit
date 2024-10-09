import UIKit
import Combine
import PizzaCore
import SnapKit

public extension Pizza.Compositional {
    typealias WrapperBlock = PizzaCompositionalWrapperBlock
}

/// Compositional block that wrap any UIView and layout to edges of compositional view
open class PizzaCompositionalWrapperBlock: PizzaCompositionalBlock {

    // MARK: - Private Properties

    private let customContentView: UIView

    // MARK: - Initialization

    public init(content: UIView) {
        self.customContentView = content
        super.init(subblocks: [])
    }

    // MARK: - PizzaCompositionalBlock

    open override func initialize(parent: UIView) {
        super.initialize(parent: parent)

        customContentView.do {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
