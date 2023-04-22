public struct ComponentSection: Hashable { // TODO: rename to ComponentSection
    public static func == (lhs: ComponentSection, rhs: ComponentSection) -> Bool {
        return lhs.id == rhs.id
            && lhs.headerNode?.id == rhs.headerNode?.id
            && lhs.footerNode?.id == rhs.footerNode?.id
    }

    public var id: AnyHashable
    public var headerNode: ComponentNode?
    public var cellsNode: [ComponentNode]
    public var footerNode: ComponentNode?

    public init(
        id: AnyHashable,
        header: (any IdentifiableComponent)? = nil,
        cells: [any IdentifiableComponent] = [],
        footer: (any IdentifiableComponent)? = nil
    ) {
        self.id = id
        self.headerNode = header.map { .init(component: $0) }
        self.cellsNode = cells.map { .init(component: $0) }
        self.footerNode = footer.map { .init(component: $0) }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        if let headerNode {
            hasher.combine(headerNode.id)
        }
        if let footerNode {
            hasher.combine(footerNode.id)
        }
    }
}
