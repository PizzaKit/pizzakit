public struct Section: Hashable {
    public static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
            && lhs.header?.id == rhs.header?.id
            && lhs.footer?.id == rhs.footer?.id
    }

    public var id: AnyHashable
    public var header: CellNode?
    public var cells: [CellNode]
    public var footer: CellNode?

    public init(
        id: AnyHashable,
        header: CellNode? = nil,
        cells: [CellNode] = [],
        footer: CellNode? = nil
    ) {
        self.id = id
        self.header = header
        self.cells = cells
        self.footer = footer
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        if let header {
            hasher.combine(header.id)
        }
        if let footer {
            hasher.combine(footer.id)
        }
    }
}
