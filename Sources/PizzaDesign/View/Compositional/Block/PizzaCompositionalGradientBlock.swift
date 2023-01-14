import UIKit
import Combine
import PizzaCore

public extension Pizza.Compositional {
    typealias GradientBlock = PizzaCompositionalGradientBlock
}

/// Compositional block for adding gradient
open class PizzaCompositionalGradientBlock: PizzaCompositionalBlock {

    /// Contains gradient confgiuration
    public struct GradientConfiguration {
        public let startPosition: GradientPosition
        public let endPosition: GradientPosition
        public let colors: [UIColor]
        public let opacity: Float

        public init(
            startPosition: GradientPosition,
            endPosition: GradientPosition,
            colors: [UIColor],
            opacity: Float = 1
        ) {
            self.startPosition = startPosition
            self.endPosition = endPosition
            self.colors = colors
            self.opacity = opacity
        }
    }

    /// Describe gradient position
    public enum GradientPosition {
        case top, right, bottom, left
        case topLeft, topRight, bottomLeft, bottomRight

        var point: CGPoint {
            switch self {
            case .top:
                return .init(x: 0.5, y: 0)
            case .right:
                return .init(x: 1, y: 0.5)
            case .bottom:
                return .init(x: 0.5, y: 1)
            case .left:
                return .init(x: 0, y: 0.5)
            case .topLeft:
                return .init(x: 0, y: 0)
            case .topRight:
                return .init(x: 1, y: 0)
            case .bottomLeft:
                return .init(x: 0, y: 1)
            case .bottomRight:
                return .init(x: 1, y: 1)
            }
        }
    }

    // MARK: - Private Properties
    private let gradientLayer = CAGradientLayer()
    private var gradientConfiguration: GradientConfiguration? {
        didSet {
            gradientLayer.do {
                $0.startPoint = gradientConfiguration?.startPosition.point ?? .zero
                $0.endPoint = gradientConfiguration?.endPosition.point ?? .zero
                $0.colors = gradientConfiguration?.colors.map { $0.cgColor } ?? []
                $0.opacity = gradientConfiguration?.opacity ?? 0
            }
        }
    }

    // MARK: - Methods

    @discardableResult
    public func gradientConfiguration(
        publisher: AnyPublisher<GradientConfiguration?, Never>
    ) -> Self {

        publisher.sink { [weak self] newGradientConfiguration in
            self?.gradientConfiguration = newGradientConfiguration
        }.store(in: &bag)

        return self
    }

    @discardableResult
    public func gradientConfiguration(
        _ newGradientConfiguration: GradientConfiguration?
    ) -> Self {

        gradientConfiguration = newGradientConfiguration

        return self
    }

    // MARK: - PizzaCompositionalBlock

    open override func initialize(parent: UIView) {
        super.initialize(parent: parent)
        parent.layer.addSublayer(gradientLayer)
    }
    open override func layoutSublayers(parent: UIView) {
        super.layoutSublayers(parent: parent)
        gradientLayer.frame = parent.layer.bounds
    }

}
