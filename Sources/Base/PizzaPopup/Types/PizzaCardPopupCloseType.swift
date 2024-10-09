public enum PizzaCardPopupCloseType {
    case closeButton
    case swiped
    case onActionButton(buttonId: String)
    case fromPresenter(actionId: String?)
}
