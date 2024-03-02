import Foundation

public extension Double {

    func rounded(roundDigits: Int) -> Double {
        let multiplier = pow(10, Double(roundDigits))
        let rounded = Double(Int(Double(self * multiplier).rounded()))
        return rounded / multiplier
    }

    func isNearlyEqual(to other: Double, delta: Double) -> Bool {
        abs(other - self) < delta
    }

}
