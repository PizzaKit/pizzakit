import Foundation

public enum PizzaPricePercentageHelpers {

    private static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .up
        return formatter
    }()

    public static func formatted(
        durationWithPriceAfterDiscount: PizzaPriceHelpers.DurationWithPrice,
        durationWithPriceBeforeDiscount: PizzaPriceHelpers.DurationWithPrice
    ) -> String? {
        return formatted(
            priceAfterDiscount: durationWithPriceAfterDiscount.pricePerDay,
            priceBeforeDiscount: durationWithPriceBeforeDiscount.pricePerDay
        )
    }

    public static func formatted(
        priceAfterDiscount: Decimal,
        priceBeforeDiscount: Decimal
    ) -> String? {
        let percent = (priceAfterDiscount / priceBeforeDiscount) - 1
        return percentageFormatter.string(from: percent as NSNumber)
    }

}
