import PizzaKit

public struct PizzaNativeDesignSystemLoader {
    public init(isRoundedFont: Bool) {
        FontRoundStorage.needRounded = isRoundedFont
    }
    public func load() {
        PizzaDesignSystemStore.currentDesignSystem = PizzaNativeDesignSystem()
    }
}
