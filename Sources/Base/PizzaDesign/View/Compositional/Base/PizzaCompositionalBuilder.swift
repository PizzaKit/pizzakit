@resultBuilder
public enum PizzaCompositionalBuilder {
    public static func buildBlock(_ components: PizzaCompositionalBlock...) -> [PizzaCompositionalBlock] {
        components
    }
}
