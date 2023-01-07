import UIKit

/// View for passing touches to another view
/// (see `eventForwardingView`)
open class PizzaPassthroughView: PizzaView {

    /// View for passing touches
    public weak var eventForwardingView: UIView?

    open override func hitTest(
        _ point: CGPoint,
        with event: UIEvent?
    ) -> UIView? {
        let target = super.hitTest(point, with: event)

        if target === self {
            return eventForwardingView?
                .hitTest(
                    self.convert(
                        point,
                        to: eventForwardingView
                    ),
                    with: event
                )
        }

        return target
    }
}
