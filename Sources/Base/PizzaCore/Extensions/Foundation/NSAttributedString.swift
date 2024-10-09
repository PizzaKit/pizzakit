import Foundation

public extension NSAttributedString {

    func width(
        withConstrainedHeight height: CGFloat
    ) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return ceil(boundingBox.width)
    }

    func height(
        withConstrainedWidth width: CGFloat
    ) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return ceil(boundingBox.height)
    }

}
