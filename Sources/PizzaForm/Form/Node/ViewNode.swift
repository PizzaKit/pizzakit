/// элемент для diffablDataSource. Содержит в себе компонент, который будет рендерится
/// в header/footer view
public struct ViewNode {

    public let component: any Component

    public init(component: any Component) {
        self.component = component
    }

}
