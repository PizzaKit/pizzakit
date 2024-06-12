import UIKit
import PizzaCore
import SnapKit

public enum PizzaAlignWrapperView {

    public class Vertical: PizzaView {

        public enum AlignmentType {
            case centerY
            case top
            case bottom
        }

        private let contentView: UIView
        private let alignment: AlignmentType
        private let insets: UIEdgeInsets

        public init(
            contentView: UIView,
            alignment: AlignmentType,
            insets: UIEdgeInsets = .zero
        ) {
            self.contentView = contentView
            self.alignment = alignment
            self.insets = insets
            super.init(frame: .zero)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func commonInit() {
            super.commonInit()

            addSubview(contentView)
            switch alignment {
            case .centerY:
                contentView.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview().inset(insets)
                    make.centerY.equalToSuperview()
                    make.top.greaterThanOrEqualToSuperview().inset(insets)
                }
            case .top:
                contentView.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview().inset(insets)
                    make.top.equalToSuperview().inset(insets)
                    make.bottom.lessThanOrEqualToSuperview().inset(insets)
                }
            case .bottom:
                contentView.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview().inset(insets)
                    make.bottom.equalToSuperview().inset(insets)
                    make.top.greaterThanOrEqualToSuperview().inset(insets)
                }
            }
        }

    }

    public class Horizontal: PizzaView {

        public enum AlignmentType {
            case centerX
            case leading
            case trailing
        }

        private let contentView: UIView
        private let alignment: AlignmentType
        private let insets: UIEdgeInsets

        public init(
            contentView: UIView,
            alignment: AlignmentType,
            insets: UIEdgeInsets = .zero
        ) {
            self.contentView = contentView
            self.alignment = alignment
            self.insets = insets
            super.init(frame: .zero)
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func commonInit() {
            super.commonInit()

            addSubview(contentView)
            switch alignment {
            case .centerX:
                contentView.snp.makeConstraints { make in
                    make.verticalEdges.equalToSuperview().inset(insets)
                    make.centerX.equalToSuperview()
                    make.leading.greaterThanOrEqualToSuperview().inset(insets)
                }
            case .leading:
                contentView.snp.makeConstraints { make in
                    make.verticalEdges.equalToSuperview().inset(insets)
                    make.leading.equalToSuperview().inset(insets)
                    make.trailing.lessThanOrEqualToSuperview().inset(insets)
                }
            case .trailing:
                contentView.snp.makeConstraints { make in
                    make.verticalEdges.equalToSuperview().inset(insets)
                    make.trailing.equalToSuperview().inset(insets)
                    make.leading.greaterThanOrEqualToSuperview().inset(insets)
                }
            }
        }

    }

}
