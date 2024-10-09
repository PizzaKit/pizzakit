import PizzaCore
import UIKit
import SnapKit
import Combine

public extension Pizza.Compositional {
    typealias Block = PizzaCompositionalBlock
}

/// Base block thar renders as view with some additions
open class PizzaCompositionalBlock {

    // MARK: - Nested Types

    /// Shadow configuration
    public struct ShadowConfiguration {
        public let color: UIColor
        public let radius: CGFloat
        public let opacity: Float
        public let offset: CGSize

        public init(
            color: UIColor,
            radius: CGFloat,
            opacity: Float,
            offset: CGSize
        ) {
            self.color = color
            self.radius = radius
            self.opacity = opacity
            self.offset = offset
        }
    }

    // MARK: - Properties

    // Content view that renders on screen. All subviews must be added here
    public let contentView = PizzaView()
    // Subblocks to current block (nested depth could be any)
    public let subblocks: [PizzaCompositionalBlock]
    // Configuration for shadow
    private var shadowConfiguration: ShadowConfiguration? {
        didSet {
            contentView.layer.do {
                $0.shadowColor = shadowConfiguration?.color.cgColor
                $0.shadowRadius = shadowConfiguration?.radius ?? 0
                $0.shadowOpacity = shadowConfiguration?.opacity ?? 0
                $0.shadowOffset = shadowConfiguration?.offset ?? .zero
            }
        }
    }
    public var bag = Set<AnyCancellable>()

    // Called when child needed relayout
    var onNeedRelayout: PizzaEmptyClosure?

    // MARK: - Initialization

    public init(subblocks: [PizzaCompositionalBlock]) {
        self.subblocks = subblocks

        self.subblocks.forEach {
            $0.onNeedRelayout = { [weak self] in
                self?.onNeedRelayout?()
            }
        }
    }

    public convenience init(
        @PizzaCompositionalBuilder _ builder: () -> [PizzaCompositionalBlock]
    ) {
        self.init(subblocks: builder())
    }
    public convenience init() {
        self.init(subblocks: [])
    }

    // MARK: - Methods

    @discardableResult
    public func shadowConfiguration(
        publisher: AnyPublisher<ShadowConfiguration?, Never>
    ) -> Self {

        publisher.sink { [weak self] newShadowConfiguration in
            self?.shadowConfiguration = newShadowConfiguration
        }.store(in: &bag)

        return self
    }

    @discardableResult
    public func shadowConfiguration(
        _ newShadowConfiguration: ShadowConfiguration?
    ) -> Self {

        shadowConfiguration = newShadowConfiguration

        return self
    }

    @discardableResult
    public func backgroundColor(
        publisher: AnyPublisher<UIColor?, Never>
    ) -> Self {

        publisher.sink { [weak self] newColor in
            self?.contentView.backgroundColor = newColor
        }.store(in: &bag)

        return self
    }

    @discardableResult
    public func backgroundColor(
        _ backgroundColor: UIColor?
    ) -> Self {

        contentView.backgroundColor = backgroundColor

        return self
    }

    // MARK: - Base Class Methods

    open func initialize(parent: UIView) {
        contentView.do {
            parent.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        subblocks.forEach { $0.initialize(parent: contentView) }
    }

    open func layoutSubviews(parent: UIView) {
        subblocks.forEach { $0.layoutSubviews(parent: contentView) }
    }

    open func layoutSublayers(parent: UIView) {
        subblocks.forEach { $0.layoutSublayers(parent: contentView) }
    }

}
