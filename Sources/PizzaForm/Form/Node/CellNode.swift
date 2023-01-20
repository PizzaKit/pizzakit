/// элемент для diffablDataSource. Содержит в себе компонент, который будет рендерится
/// в ячейку
public struct CellNode: Hashable {

    public let id: AnyHashable
    public let component: any Component

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: CellNode, rhs: CellNode) -> Bool {
        lhs.id == rhs.id
    }

    public init<ID: Hashable>(id: ID, component: any Component) {
        if type(of: id) == AnyHashable.self {
            self.id = unsafeBitCast(id, to: AnyHashable.self)
        }
        else {
            self.id = id
        }
        self.component = component
    }

    public init<IComponent: IdentifiableComponent>(component: IComponent) {
        self.init(id: component.id, component: component)
    }

}

extension CellNode: CustomStringConvertible {
    public var description: String {
        "(Cell node with id: \(id) component: \(component)"
    }
}
