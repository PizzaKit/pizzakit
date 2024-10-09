public protocol PizzaCardPopupPresenterDelegate: AnyObject {

    func forceDismiss(presenterActionId: String?)

}

public protocol PizzaCardPopupPresenter {

    var delegate: PizzaCardPopupPresenterDelegate? { get set }

    func needClosePopup(buttonId: String) -> Bool

    func needButtonAction(buttonId: String) -> Bool

}
