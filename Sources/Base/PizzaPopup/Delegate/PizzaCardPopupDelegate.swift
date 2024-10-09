public protocol PizzaCardPopupDelegate {
    func popupOpened()
    func popupClosed(closeType: PizzaCardPopupCloseType)
}
