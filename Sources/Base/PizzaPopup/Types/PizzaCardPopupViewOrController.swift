/// Custom view для попапа. Когда имплементируем этот протокол,
/// важно всегда вызывать `SmileCardPopup.dismiss` и правильно работать `onClosed`:
/// - перед dismiss вызвать `onClosed.fill(closeType:)`
/// - в completion-е `dismiss` вызвать `onClosed.callCompletionJustOnce()`
/// Также важно не забыть про `deinit`:
/// - вызвать `onClosed.callCompletionJustOnce()`
public protocol PizzaCardPopupViewOrController: PizzaCardPopupPresenterDelegate {

    var onClosed: PizzaCardPopupCloseFireWrapper { get }

    /// Внутри обязательно выставить delegate presenter-а в self
    func configure(presenter: PizzaCardPopupPresenter)

}

public extension PizzaCardPopupViewOrController {

    func forceDismiss(presenterActionId: String?) {
        onClosed.fill(closeType: .fromPresenter(actionId: presenterActionId))
        PizzaCardPopup.dismiss {
            self.onClosed.callCompletionJustOnce()
        }
    }

}
