import PizzaCore
import SnapKit
import UIKit

public class PizzaScrollableTeaserView: PizzaView {

    private let scrollView = UIScrollView()
    private let teaserView: PizzaTeaserView

    public init(
        info: PizzaTeaserInfo,
        style: PizzaTeaserInfoStyle
    ) {
        self.teaserView = .init(
            info: info,
            style: style
        )
        super.init(frame: .zero)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func commonInit() {
        super.commonInit()

        scrollView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        teaserView.do {
            scrollView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalToSuperview()
                make.height.greaterThanOrEqualToSuperview()
            }
        }
    }

}
