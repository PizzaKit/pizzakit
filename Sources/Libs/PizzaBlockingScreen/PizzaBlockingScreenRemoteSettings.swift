import PizzaKit
import Foundation

public struct PizzaBlockingScreenRemoteSettings: Codable, PizzaFeatureToggleJSONValueType {

    public struct ButtonActionContext: Codable {
        public let url: String
        public let closeAfterOpeningURL: Bool

        public init(url: String, closeAfterOpeningURL: Bool) {
            self.url = url
            self.closeAfterOpeningURL = closeAfterOpeningURL
        }
    }

    public struct Button: Codable {
        public let title: String
        public let actionContext: ButtonActionContext

        public init(title: String, actionContext: ButtonActionContext) {
            self.title = title
            self.actionContext = actionContext
        }
    }

    public struct Icon: Codable {
        public let sfSymbol: String?
        public let assetName: String?

        public init(sfSymbol: String?, assetName: String?) {
            self.sfSymbol = sfSymbol
            self.assetName = assetName
        }
    }

    public enum VersionRequirementType: String, Codable {
        case exact = "="
        case less = "<"
        case lessOrEqual = "<="
        case greater = ">"
        case greaterOrEqual = ">="
    }

    public enum NextLaunchOpenPolicy: String, Codable {
        case openEveryTime
        case openOnlyIfSkipPressed
        case notOpen
    }

    public struct Requirements: Codable {
        public let version: PizzaVersion?
        public let versionRequirementType: VersionRequirementType?
        public let languageCode: String?
    }

    public let id: String
    public let title: String
    public let desc: String?
    public let icon: Icon
    public let button: Button?
    public let closeButtonName: String?
    public let requirements: Requirements?
    public let nextLaunchOpenPolicy: NextLaunchOpenPolicy

    public var shouldBeShown: Bool {
        localeRequirementMatch && versionRequirementMatch
    }
    private var localeRequirementMatch: Bool {
        guard
            let locale = Locale.current.languageCode,
            let localeRequirement = requirements?.languageCode
        else {
            return true
        }
        return locale == localeRequirement
    }
    private var versionRequirementMatch: Bool {
        guard
            let currentAppVersion = PizzaVersion.fromBundle,
            let version = requirements?.version,
            let versionRequirementType = requirements?.versionRequirementType
        else { return true }

        switch versionRequirementType {
        case .exact:
            return currentAppVersion == version
        case .less:
            return currentAppVersion < version
        case .lessOrEqual:
            return currentAppVersion <= version
        case .greater:
            return currentAppVersion > version
        case .greaterOrEqual:
            return currentAppVersion >= version
        }
    }

    public init(
        id: String,
        title: String,
        desc: String?,
        icon: Icon,
        button: Button?,
        closeButtonName: String?,
        requirements: Requirements?,
        nextLaunchOpenPolicy: NextLaunchOpenPolicy
    ) {
        self.id = id
        self.title = title
        self.desc = desc
        self.icon = icon
        self.button = button
        self.closeButtonName = closeButtonName
        self.requirements = requirements
        self.nextLaunchOpenPolicy = nextLaunchOpenPolicy
    }

    private var requirementDescription: String {
        if let requirements {
            return "\(requirements.versionRequirementType?.rawValue ?? "nil") \(requirements.version ?? "nil") \(requirements.languageCode ?? "nil")"
        }
        return "nil"
    }
    public var description: String {
        """
        PizzaBlockingScreenRemoteSettings (
            id: \(id),
            title: \(title),
            desc: \(desc ?? "<none>"),
            requirement: \(requirementDescription)
        )
        """
    }

}

public extension PizzaFeatureToggle {

    static var blockingScreens: PizzaFeatureToggle<[PizzaBlockingScreenRemoteSettings]> {
        PizzaFeatureToggle<[PizzaBlockingScreenRemoteSettings]>(
            key: "blocking_screens",
            defaultValue: []
        )
    }

}
