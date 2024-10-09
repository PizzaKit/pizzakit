import Foundation

public enum PizzaVersionCodingError: Error {
    case couldNotBePresented
}

public struct PizzaVersion: Comparable, Equatable, ExpressibleByStringLiteral, CustomStringConvertible, Codable {

    public let major: Int
    public let minor: Int
    public let patch: Int
    public let preReleaseIdentifiers: ArraySlice<String>
    public let rawValue: String

    public var description: String {
        return rawValue
    }

    public static var fromBundle: PizzaVersion? {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String).flatMap(PizzaVersion.init(rawValue:))
    }

    public init(stringLiteral value: StringLiteralType) {
        guard let instance = PizzaVersion(rawValue: value) else {
            preconditionFailure("failed to initialize `AppVersion` using string literal '\(value)'.")
        }
        self = instance
    }

    public init?(rawValue: String) {
        let normalVersionAndPreRelease = Array(rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "-"))
        let preReleaseIdentifiers = normalVersionAndPreRelease.dropFirst()

        guard !(normalVersionAndPreRelease.contains("")),
              !(preReleaseIdentifiers.contains { $0.hasLeadingZero }),
              !(preReleaseIdentifiers.contains { !($0.isAlphanumeric) }),
              let rawNormalVersion = normalVersionAndPreRelease.first else {
            return nil
        }

        let normalVersionComponents = Array(rawNormalVersion
            .removeFirstCharacter(ifMatches: "v")
            .components(separatedBy: "."))
            .filter { !$0.hasLeadingZero }
            .compactMap { Int($0) }
            .filter { $0.isNonNegative }

        guard normalVersionComponents.count == 3 else {
            return nil
        }

        self.rawValue = rawValue
        self.major = normalVersionComponents[0]
        self.minor = normalVersionComponents[1]
        self.patch = normalVersionComponents[2]
        self.preReleaseIdentifiers = preReleaseIdentifiers
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let appVersionRaw = try container.decode(String.self)
        guard let appVersion = PizzaVersion(rawValue: appVersionRaw) else {
            throw PizzaVersionCodingError.couldNotBePresented
        }
        self = appVersion
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    // MARK: - SemVer

    public var isStable: Bool {
        return isPublic && !isPreRelease
    }

    public var isPublic: Bool {
        return self >= PizzaVersion(rawValue: "1.0.0")!
    }

    public var isPreRelease: Bool {
        return !(preReleaseIdentifiers.isEmpty)
    }

    public func nextMajor() -> PizzaVersion {
        return PizzaVersion(rawValue: "\(major+1).0.0")!
    }

    public func nextMinor() -> PizzaVersion {
        return PizzaVersion(rawValue: "\(major).\(minor+1).0")!
    }

    public func nextPatch() -> PizzaVersion {
        return PizzaVersion(rawValue: "\(major).\(minor).\(patch+1)")!
    }

}

// MARK: - Protocol conformance

// MARK: Comparable

public func <(lhs: PizzaVersion, rhs: PizzaVersion) -> Bool {
    if lhs.major != rhs.major {
        return lhs.major < rhs.major
    }

    if lhs.minor != rhs.minor {
        return lhs.minor < rhs.minor
    }

    if lhs.patch != rhs.patch {
        return lhs.patch < rhs.patch
    }

    // lhs and rhs have same normal version;
    // lhs is only less-than if it is a preRelease
    return lhs.isPreRelease && !rhs.isPreRelease
}

// MARK: Equatable

public func ==(lhs: PizzaVersion, rhs: PizzaVersion) -> Bool {
    return lhs.major == rhs.major
    && lhs.minor == rhs.minor
    && lhs.patch == rhs.patch
    && lhs.preReleaseIdentifiers == rhs.preReleaseIdentifiers
}

fileprivate extension Int {

    var isNonNegative: Bool {
        return self >= 0
    }

}

fileprivate extension String {

    var isAlphanumeric: Bool {
        guard !isEmpty else {
            return false
        }
        return range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    var hasLeadingZero: Bool {
        guard !isEmpty else {
            return false
        }
        return count > 1 && first == "0"
    }

    func removeFirstCharacter(ifMatches character: Character) -> String {
        if let first = first, first == character {
            return String(self.dropFirst())
        }
        return self
    }

}
