import UIKit
import PizzaCore

/// View for handling press and touch gestures.
/// Press started when user begin touch, press ended when user ended or cancelled touch.
/// This view for changing some properties on press (for example animating) and reacting on tap.
open class PizzaPressableView: PizzaView {

    // MARK: - Private Properties

    private var onPress: PizzaClosure<Bool>?
    private var onTouch: PizzaEmptyClosure?

    public private(set) var startPoint: CGPoint?
    private var isPressed: Bool = false {
        didSet {
            if isPressed != oldValue {
                onPress?(isPressed)
            }
            if !isPressed {
                startPoint = nil
            }
        }
    }

    private var tapGestureRecognizer: UITapGestureRecognizer!

    // MARK: - UIView

    open override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
        guard tapGestureRecognizer.isEnabled else { return }

        if let touch = touches.first {
            let location = touch.location(in: self)
            startPoint = location
        }

        isPressed = true
    }

    open override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesEnded(touches, with: event)
        guard tapGestureRecognizer.isEnabled else { return }

        isPressed = false
    }

    open override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesCancelled(touches, with: event)
        guard tapGestureRecognizer.isEnabled else { return }
        
        isPressed = false
    }

    open override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesMoved(touches, with: event)
        guard tapGestureRecognizer.isEnabled else { return }
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let isPointContains = bounds.contains(location)
            isPressed = isPointContains
        }
    }

    // MARK: - Methods


    /// Method for configuring press and touch closures
    @discardableResult
    open func configure(
        onPress: PizzaClosure<Bool>?,
        onTouch: PizzaEmptyClosure?
    ) -> Self {
        self.onPress = onPress
        self.onTouch = onTouch

        return self
    }

    /// Method for configuring enabled state
    /// (default enabled)
    @discardableResult
    open func configure(touchEnabled: Bool) -> Self {
        tapGestureRecognizer.isEnabled = touchEnabled

        return self
    }

    // MARK: - Actions

    @objc
    private func handleTap() {
        onTouch?()
    }

    // MARK: - Appearance

    open override func commonInit() {
        super.commonInit()
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        addGestureRecognizer(tapGestureRecognizer)
    }

}
