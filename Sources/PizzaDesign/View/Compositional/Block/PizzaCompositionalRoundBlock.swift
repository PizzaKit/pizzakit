import UIKit
import Combine
import PizzaCore

public extension Pizza.Compositional {
    typealias RoundedBlock = PizzaCompositionalRoundBlock
}

/// Compositional block for adding corner radius
open class PizzaCompositionalRoundBlock: PizzaCompositionalBlock {

    // MARK: - Nested Types

    /// Describe size of corner radius for view
    public enum RoundSizeType {
        case fractionalWidth(CGFloat), fractionalHeight(CGFloat), absolute(CGFloat)
    }

    // MARK: - Private Properties

    private var roundSizeType: RoundSizeType? {
        didSet {
            onNeedRelayout?()
        }
    }
    private var maskToBounds: Bool = true {
        didSet {
            updateMaskToBounds()
        }
    }

    // MARK: - Methods

    @discardableResult
    public func roundSizeType(
        publisher: AnyPublisher<RoundSizeType?, Never>
    ) -> Self {

        publisher.sink { [weak self] newRoundSizeType in
            self?.roundSizeType = newRoundSizeType
        }.store(in: &bag)

        return self
    }

    @discardableResult
    public func roundSizeType(
        _ newRoundSizeType: RoundSizeType?
    ) -> Self {

        roundSizeType = newRoundSizeType

        return self
    }

    @discardableResult
    public func maskToBounds(
        publisher: AnyPublisher<Bool, Never>
    ) -> Self {

        publisher.sink { [weak self] newMaskToBounds in
            self?.maskToBounds = newMaskToBounds
        }.store(in: &bag)

        return self
    }

    @discardableResult
    public func maskToBounds(
        _ newMaskToBounds: Bool
    ) -> Self {

        maskToBounds = newMaskToBounds

        return self
    }

    // MARK: - PizzaCompositionalBlock

    open override func initialize(parent: UIView) {
        super.initialize(parent: parent)

        updateMaskToBounds()
    }

    open override func layoutSubviews(parent: UIView) {
        super.layoutSubviews(parent: parent)

        switch roundSizeType {
        case .fractionalWidth(let fractionalValue):
            contentView.layer.cornerRadius = parent.bounds.width * fractionalValue
        case .fractionalHeight(let fractionalValue):
            contentView.layer.cornerRadius = parent.bounds.height * fractionalValue
        case .absolute(let absoluteValue):
            contentView.layer.cornerRadius = absoluteValue
        case .none:
            contentView.layer.cornerRadius = 0
        }
    }

    // MARK: - Private Methods

    private func updateMaskToBounds() {
        contentView.layer.do {
            $0.masksToBounds = maskToBounds
        }
    }

}
