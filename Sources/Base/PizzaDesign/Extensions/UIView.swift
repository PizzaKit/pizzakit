import UIKit
import SnapKit

public extension UIView {

    func addSubviewAndPinEdges(_ subview: UIView, useHorizontalMargins: Bool = false) {
        subview.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make
                    .top
                    .equalToSuperview()

                make
                    .bottom
                    .equalToSuperview()
                    .priority(999)

                if useHorizontalMargins {
                    make.leading.equalTo(layoutMarginsGuide.snp.leading)

                    make
                        .trailing
                        .equalTo(layoutMarginsGuide.snp.trailing)
                        .priority(999)
                } else {
                    make.leading.equalToSuperview()

                    make
                        .trailing
                        .equalToSuperview()
                        .priority(999)
                }
            }
        }
    }

}
