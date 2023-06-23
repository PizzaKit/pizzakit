import UIKit

public extension CALayer {

    var presentationOrSelf: Self {
        presentation() ?? self
    }

}
