public extension Array {

    /// Initialize array with repeated items
    /// - Parameters:
    ///   - repeating: item to repeat
    ///   - count: number of repeatings
    init(repeating: (() -> Element), count: Int) {
        self = []
        for _ in 0..<count {
            self.append(repeating())
        }
    }

    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

}
