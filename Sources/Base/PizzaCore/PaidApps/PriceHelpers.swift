import Foundation

public enum PizzaPriceHelpers {

    public enum DurationUnit {
        case day
        case week
        case month
        case year
    }

    public struct Duration {
        let unit: DurationUnit
        let value: Int

        var numberOfDays: Int {
            switch unit {
            case .day:
                return value
            case .week:
                return value * 7
            case .month:
                return value * 30
            case .year:
                return value * 365
            }
        }

        public init(
            unit: DurationUnit,
            value: Int = 1
        ) {
            self.unit = unit
            self.value = value
        }
    }

    public struct DurationWithPrice {
        let unit: DurationUnit
        let value: Int
        let price: Decimal

        var numberOfDays: Int {
            switch unit {
            case .day:
                return value
            case .week:
                return value * 7
            case .month:
                return value * 30
            case .year:
                return value * 365
            }
        }
        var pricePerDay: Decimal {
            price / Decimal(numberOfDays)
        }

        public init(
            unit: DurationUnit,
            value: Int = 1,
            price: Decimal
        ) {
            self.unit = unit
            self.value = value
            self.price = price
        }
    }

    public static func formatted(
        durationWithPrice: DurationWithPrice,
        targetDuration: Duration,
        priceLocale: Locale?,
        currencyCode: String?
    ) -> String {
        let pricePerDay = durationWithPrice.pricePerDay
        let targetNumberOfDays = targetDuration.numberOfDays
        return formatted(
            price: pricePerDay * Decimal(targetNumberOfDays),
            priceLocale: priceLocale,
            currencyCode: currencyCode
        )
    }

    public static func formatted(
        price: Decimal,
        priceLocale: Locale?,
        currencyCode: String?,
        block: (Decimal) -> Decimal = { $0 }
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let priceLocale {
            formatter.locale = priceLocale
            let numberOfDigits = numberOfFractionDigits(for: priceLocale)
            formatter.minimumFractionDigits = numberOfDigits
            formatter.maximumFractionDigits = numberOfDigits
            formatter.roundingMode = .down
        }
        if let currencyCode {
            formatter.currencyCode = currencyCode
        }
        let newPrice = block(price)
        return formatter.string(
            from: newPrice as NSDecimalNumber
        )!
    }

    private static func numberOfFractionDigits(for priceLocale: Locale) -> Int {
        // Get the currency code for the current locale
        let currencyCode = priceLocale.currencyCode ?? ""

        // Dictionary specifying the number of fraction digits for each currency
        let fractionDigits: [String: Int] = [
            "USD": 2,   // United States Dollar
            "EUR": 2,   // Euro
            "AUD": 2,   // Australian Dollar
            "BGN": 2,   // Bulgarian Lev
            "ILS": 2,   // Israeli Shekel
            "QAR": 2,   // Qatari Riyal
            "EGP": 2,   // Egyptian Pound
            "PEN": 2,   // Peruvian Sol
            "PLN": 2,   // Polish Zloty
            "RON": 2,   // Romanian Leu
            "SAR": 2,   // Saudi Riyal
            "TRY": 2,   // Turkish Lira
            "PHP": 2,   // Philippine Peso
            "CHF": 2,   // Swiss Franc
            "CAD": 2,   // Canadian Dollar
            "SGD": 2,   // Singapore Dollar
            "MXN": 2,   // Mexican Peso
            "BRL": 2,   // Brazilian Real
            "MYR": 2,   // Malaysian Ringgit
            "ZAR": 2,   // South African Rand
            "RUB": 0,   // Russian Ruble
            "JPY": 0,   // Japanese Yen
            "KRW": 0,   // South Korean Won
            "HUF": 0,   // Hungarian Forint
            "VND": 0,   // Vietnamese Dong
            "KZT": 0,   // Kazakhstani Tenge
            "INR": 0,   // Indian Rupee
            "IDR": 0,   // Indonesian Rupiah
            "NGN": 0,   // Nigerian Naira
            "TWD": 0,   // Taiwan Dollar
            "TZS": 0,   // Tanzanian Shilling
            "THB": 0,   // Thai Baht
            "COP": 0,   // Colombian Peso
            "CLP": 0,   // Chilean Peso
            "CZK": 0,   // Czech Koruna
            "SEK": 0,   // Swedish Krona
            "DKK": 0,   // Danish Krone
            "NOK": 0,   // Norwegian Krone
            "CNY": 0,   // Chinese Yuan
            "HKD": 0    // Hong Kong Dollar
        ]

        // Return the number of fraction digits for the given currency
        return fractionDigits[currencyCode] ?? 2
    }

}
