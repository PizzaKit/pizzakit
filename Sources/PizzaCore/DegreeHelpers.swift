import Foundation

public func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}
public func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

public func rad2deg(_ number: Double) -> Double {
    return number * 180 / .pi
}
public func rad2deg(_ number: CGFloat) -> CGFloat {
    return number * 180 / .pi
}
