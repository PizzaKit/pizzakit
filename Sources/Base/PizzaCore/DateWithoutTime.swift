import Foundation

public struct DateWithoutTime: Equatable, Hashable {
    // MARK: - Creating an instance

    /// Returns a date string initialized using their ISO 8601 representation.
    /// - Parameters:
    ///   - dateAsString: The ISO 8601 representation of the date. For instance, `2022-03-02`for March 2nd of 2022.
    ///   - calendar: The calendar — including the time zone — to use. The default is the current calendar.
    /// - Returns: A date string, or `nil` if a valid date could not be created from `dateAsString`.
    public init?(from dateAsString: String, calendar: Calendar = .current) {
        let formatter = Self.createFormatter(timeZone: calendar.timeZone)
        guard let date = formatter.date(from: dateAsString) else {
            return nil
        }

        self.init(date: date, calendar: calendar, formatter: formatter)
    }

    /// Returns a date string initialized using their ISO 8601 representation.
    /// - Parameters:
    ///   - date: The date to represent.
    ///   - calendar: The calendar — including the time zone — to use. The default is the current calendar.
    public init(date: Date, calendar: Calendar = .current) {
        self.init(date: date, calendar: calendar, formatter: Self.createFormatter(timeZone: calendar.timeZone))
    }

    private init(date: Date, calendar: Calendar = .current, formatter: ISO8601DateFormatter) {
        self.formatter = formatter
        self.date = date
        self.calendar = calendar
    }

    public static var today: DateWithoutTime {
        .init(date: Date())
    }

    // MARK: - Properties

    private let formatter: ISO8601DateFormatter
    private let date: Date
    private let calendar: Calendar

    private static func createFormatter(timeZone: TimeZone) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        formatter.timeZone = timeZone
        return formatter
    }

    public var rawValue: String {
        formatter.string(from: date)
    }
    public var startDayDate: Date {
        calendar.startOfDay(for: date)
    }
    public func added(days: Int) -> DateWithoutTime {
        advanced(by: days)
    }
    public mutating func add(days: Int) {
        self = advanced(by: days)
    }

    // MARK: - Equatable

    public static func == (lhs: DateWithoutTime, rhs: DateWithoutTime) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

}

extension DateWithoutTime: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(from: value)!
    }
}

extension DateWithoutTime: Strideable {
    public func distance(to other: DateWithoutTime) -> Int {
        let timeInterval = startDayDate.distance(to: other.startDayDate)
        return Int(round(timeInterval / 86400.0))
    }

    public func advanced(by value: Int) -> DateWithoutTime {
        let newDate = calendar.date(byAdding: .day, value: value, to: startDayDate)!
        return DateWithoutTime(date: newDate, calendar: calendar, formatter: formatter)
    }
}
