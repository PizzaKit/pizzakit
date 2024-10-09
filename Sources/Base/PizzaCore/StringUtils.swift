public enum StringUtils {

    public enum Configuration {

        public struct CountStrings {
            public let thousand: String
            public let millions: String
            public let billions: String
            public init(thousand: String, millions: String, billions: String) {
                self.thousand = thousand
                self.millions = millions
                self.billions = billions
            }
        }

        public static var countStrings: CountStrings?

    }

    public static func count(from int: Int) -> String {
        guard let countStrings = Configuration.countStrings else {
            assertionFailure("`Configuration.countStrings` must be provided for `StringUtils`")
            return String(int)
        }
        switch int {
        case 0..<1_000:
            return String(int)
        case 1_000..<1_000_000:
            return [String(int / 1_000), countStrings.thousand].joined(separator: " ")
        case 1_000_000..<1_000_000_000:
            return [String(int / 1_000_000), countStrings.millions].joined(separator: " ")
        case 1_000_000_000..<1_000_000_000_000:
            return [String(int / 1_000_000_000), countStrings.billions].joined(separator: " ")
        default:
            return String(int)
        }
    }

    public static func duration(from seconds: Double) -> String {
        func normalize(string: String) -> String {
            if string.count == 1 {
                return "0\(string)"
            }
            return string
        }
        let allSecondsInt = Int(seconds)
        let onlySeconds = allSecondsInt % 60
        let onlyMinutes = (allSecondsInt / 60) % 60
        let onlyHours = allSecondsInt / 3600
        if onlyHours == 0 {
            return "\(onlyMinutes):\(normalize(string: String(onlySeconds)))"
        }
        return "\(onlyHours):\(normalize(string: String(onlyMinutes))):\(normalize(string: String(onlySeconds)))"
    }

}
