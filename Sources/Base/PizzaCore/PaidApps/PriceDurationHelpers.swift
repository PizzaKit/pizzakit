import Foundation

public enum PizzaPriceDurationHelpers {

    public static func formatted(
        duration: PizzaPriceHelpers.Duration
    ) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        switch duration.unit {
        case .day:
            formatter.allowedUnits = [.day]
            return formatter.string(
                from: DateComponents(day: duration.value)
            )
        case .week:
            formatter.allowedUnits = [.weekOfMonth]
            return formatter.string(
                from: DateComponents(weekOfMonth: duration.value)
            )
        case .month:
            formatter.allowedUnits = [.month]
            return formatter.string(
                from: DateComponents(month: duration.value)
            )
        case .year:
            formatter.allowedUnits = [.year]
            return formatter.string(
                from: DateComponents(year: duration.value)
            )
        }
    }

}
