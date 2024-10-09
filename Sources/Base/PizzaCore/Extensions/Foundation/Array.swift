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

    /// Method for unique array
    /// - Parameters:
    ///   - uniqueBlock: should return hashable element, that will be used to unique items
    ///   - isBetter: should return true if new element is better than existing (new element on first place, existing on the second)
    /// - Returns: new array with unique elements
    func unique<T: Hashable>(
        uniqueBlock: (Element) -> T,
        isBetter: (Element, Element) -> Bool
    ) -> [Element] {
        var dict: [T: Element] = [:]
        var finalArray: [Element] = []

        for item in self {
            let key = uniqueBlock(item)
            if let existing = dict[key] {
                if isBetter(item, existing) {
                    dict[key] = item
                    finalArray.append(item)
                }
            } else {
                dict[key] = item
                finalArray.append(item)
            }
        }

        return finalArray
    }

}
