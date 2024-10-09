import CoreGraphics

public extension CGFloat {

    func isNearlyEqual(to other: CGFloat, delta: CGFloat) -> Bool {
        abs(other - self) < delta
    }

}
