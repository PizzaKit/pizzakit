import PizzaCore
import UIKit

public class PizzaFakeBarButtonItem: PizzaView {

    private let titleLabel = PizzaLabel()
    private let pressableView = PizzaPressableView()

    private var handler: PizzaEmptyClosure?

    public override func commonInit() {
        super.commonInit()

        titleLabel.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        pressableView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            $0.configure(touchEnabled: true)
            $0.configure(
                onPress: { [weak self] isPressed in
                    self?.titleLabel.alpha = isPressed ? 0.5 : 1
                },
                onTouch: { [weak self] in
                    self?.handler?()
                }
            )
        }
    }

    public func configure(
        title: String,
        alignment: NSTextAlignment,
        handler: @escaping PizzaEmptyClosure
    ) {
        titleLabel.style = .allStyles.body(
            color: .tintColor,
            alignment: alignment
        )
        titleLabel.text = title

        self.handler = handler
    }

}

public class PizzaFakeNavBarView: PizzaView {

    // MARK: - Nested Types

    public struct BarButtonItem {
        public let title: String
        public let handler: PizzaEmptyClosure

        public init(title: String, handler: @escaping PizzaEmptyClosure) {
            self.title = title
            self.handler = handler
        }
    }

    // MARK: - Private Properties

    private let titleLabel = PizzaLabel()
    private let leftBarButton = PizzaFakeBarButtonItem()
    private let rightBarButton = PizzaFakeBarButtonItem()

    // MARK: - Initialization

    public override func commonInit() {
        super.commonInit()

        titleLabel.do {
            addSubview($0)
            $0.style = .allStyles.headline(
                color: .palette.label,
                alignment: .center
            )
        }

        leftBarButton.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
        }

        rightBarButton.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
        }

        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }

    // MARK: - Methods

    public func configure(
        title: String?,
        leftBarButtonItem: BarButtonItem?,
        rightBarButtonItem: BarButtonItem?
    ) {
        titleLabel.text = title
        titleLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().priority(.high)

            if leftBarButtonItem != nil {
                make.leading.equalTo(leftBarButton.snp.trailing).offset(8)
            } else {
                make.leading.greaterThanOrEqualToSuperview().offset(16)
            }

            if rightBarButtonItem != nil {
                make.trailing.equalTo(rightBarButton.snp.leading).offset(-8)
            } else {
                make.trailing.lessThanOrEqualToSuperview().offset(-16)
            }
        }

        leftBarButton.isHidden = leftBarButtonItem == nil
        if let leftBarButtonItem {
            leftBarButton.configure(
                title: leftBarButtonItem.title,
                alignment: .left,
                handler: leftBarButtonItem.handler
            )
        }

        rightBarButton.isHidden = rightBarButtonItem == nil
        if let rightBarButtonItem {
            rightBarButton.configure(
                title: rightBarButtonItem.title,
                alignment: .right,
                handler: rightBarButtonItem.handler
            )
        }
    }

}
