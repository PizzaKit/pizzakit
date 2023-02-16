public struct Section: Hashable {
    public static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }

    public var id: AnyHashable
    public var header: ViewNode?
    public var cells: [CellNode]
    public var footer: ViewNode?

    public init(
        id: AnyHashable,
        header: ViewNode? = nil,
        cells: [CellNode] = [],
        footer: ViewNode? = nil
    ) {
        self.id = id
        self.header = header
        self.cells = cells
        self.footer = footer
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
