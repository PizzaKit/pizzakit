import UIKit
import PizzaDesign
import PizzaCore
import SwiftEntryKit
import SnapKit
import SFSafeSymbols
import Combine
import PizzaIcon

public enum PizzaCardPopup {

    private static var bag = Set<AnyCancellable>()

    public static func dismiss(completion: PizzaEmptyClosure? = nil) {
        SwiftEntryKit.dismiss(with: completion)
    }

    private enum SourceType {
        case view(UIView & PizzaCardPopupViewOrController)
        case controller(UIViewController & PizzaCardPopupViewOrController)
    }
    private static func display(
        sourceType: SourceType,
        canBeSwiped: Bool,
        needCloseButton: Bool,
        needImpact: Bool,
        precedence: EKAttributes.Precedence
    ) {
        if needImpact {
            UIFeedbackGenerator.impactOccurred(.heavy)
        }

        var attributes = EKAttributes()
        attributes.windowLevel = .alerts
        attributes.position = .bottom
        attributes.precedence = precedence
        attributes.displayDuration = .infinity
        attributes.positionConstraints.size = .init(
            width: .offset(value: 8),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: PizzaDesignConstants.maxSmallWidth),
            height: .intrinsic
        )
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.positionConstraints.verticalOffset = 8
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = canBeSwiped ? .dismiss : .absorbTouches

        attributes.scroll = canBeSwiped ? .enabled(swipeable: true, pullbackAnimation: .easeOut) : .disabled

        attributes.entryBackground = .color(color: .clear)
        attributes.screenBackground = .color(color: .black.with(alpha: 0.6))
        attributes.shadow = .none

        attributes.entranceAnimation = EKAttributes.Animation(
            translate: .init(
                duration: 0.4,
                spring: .init(damping: 0.8, initialVelocity: 1)
            )
        )
        attributes.exitAnimation = EKAttributes.Animation(
            translate: .init(
                duration: 0.2
            )
        )

        switch sourceType {
        case .view(let customView):
            let wrapperView = WrapperView(
                child: customView,
                needCloseButton: needCloseButton,
                onClose: { [weak customView] in
                    customView?.onClosed.fill(closeType: .closeButton)
                    PizzaCardPopup.dismiss {
                        customView?.onClosed.callCompletionJustOnce()
                    }
                }
            )

            if UIApplication.shared.applicationState != .active {
                NotificationCenter
                    .default
                    .publisher(for: UIApplication.didBecomeActiveNotification)
                    .first()
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        SwiftEntryKit.display(
                            entry: wrapperView,
                            using: attributes
                        )
                    }
                    .store(in: &bag)
            } else {
                // to fix bug with broken background animation
                DispatchQueue.main.async {
                    SwiftEntryKit.display(
                        entry: wrapperView,
                        using: attributes
                    )
                }
            }
        case .controller(let controller):
            let wrapperController = WrapperController(
                child: controller,
                needCloseButton: needCloseButton,
                onClose: { [weak controller] in
                    controller?.onClosed.fill(closeType: .closeButton)
                    PizzaCardPopup.dismiss {
                        controller?.onClosed.callCompletionJustOnce()
                    }
                }
            )

            if UIApplication.shared.applicationState != .active {
                NotificationCenter
                    .default
                    .publisher(for: UIApplication.didBecomeActiveNotification)
                    .first()
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        SwiftEntryKit.display(
                            entry: wrapperController,
                            using: attributes
                        )
                    }
                    .store(in: &bag)
            } else {
                // to fix bug with broken background animation
                DispatchQueue.main.async {
                    SwiftEntryKit.display(
                        entry: wrapperController,
                        using: attributes
                    )
                }
            }
        }
    }

    public static func display(
        customController: UIViewController & PizzaCardPopupViewOrController,
        precedence: EKAttributes.Precedence = .enqueue(priority: .max),
        needCloseButton: Bool = true,
        canBeSwiped: Bool = true,
        needImpact: Bool = true,
        onClosed: PizzaClosure<PizzaCardPopupCloseType>? = nil,
        presenter: PizzaCardPopupPresenter? = nil,
        delegate: PizzaCardPopupDelegate? = nil
    ) {
        delegate?.popupOpened()
        if let presenter = presenter {
            customController.configure(presenter: presenter)
        }
        customController.onClosed.add { closeType in
            delegate?.popupClosed(closeType: closeType)
        }
        customController.onClosed.add { closeType in
            onClosed?(closeType)
        }
        display(
            sourceType: .controller(customController),
            canBeSwiped: canBeSwiped,
            needCloseButton: needCloseButton,
            needImpact: needImpact,
            precedence: precedence
        )
    }

    public static func display(
        customView: UIView & PizzaCardPopupViewOrController,
        precedence: EKAttributes.Precedence = .enqueue(priority: .max),
        needCloseButton: Bool = true,
        canBeSwiped: Bool = true,
        needImpact: Bool = true,
        onClosed: PizzaClosure<PizzaCardPopupCloseType>? = nil,
        presenter: PizzaCardPopupPresenter? = nil,
        delegate: PizzaCardPopupDelegate? = nil
    ) {
        delegate?.popupOpened()
        if let presenter {
            customView.configure(presenter: presenter)
        }
        customView.onClosed.add { closeType in
            delegate?.popupClosed(closeType: closeType)
        }
        customView.onClosed.add { closeType in
            onClosed?(closeType)
        }
        display(
            sourceType: .view(customView),
            canBeSwiped: canBeSwiped,
            needCloseButton: needCloseButton,
            needImpact: needImpact,
            precedence: precedence
        )
    }

    public static func display(
        info: PizzaCardPopupInfo,
        style: PizzaCardPopupInfoStyle = .init(),
        precedence: EKAttributes.Precedence = .enqueue(priority: .max),
        needCloseButton: Bool = true,
        canBeSwiped: Bool = true,
        onClosed: PizzaClosure<PizzaCardPopupCloseType>? = nil,
        presenter: PizzaCardPopupPresenter? = nil,
        delegate: PizzaCardPopupDelegate? = nil
    ) {
        let view = PizzaCardBasePopupView(
            info: info,
            style: style
        )
        display(
            customView: view,
            precedence: precedence,
            needCloseButton: needCloseButton,
            canBeSwiped: canBeSwiped,
            onClosed: onClosed,
            presenter: presenter,
            delegate: delegate
        )
    }

}

private class WrapperView: PizzaView {

    private let childView: UIView
    private let needCloseButton: Bool
    private let onClose: PizzaEmptyClosure?

    init(
        child: UIView,
        needCloseButton: Bool,
        onClose: PizzaEmptyClosure?
    ) {
        self.childView = child
        self.needCloseButton = needCloseButton
        self.onClose = onClose
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func commonInit() {
        super.commonInit()

        childView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        if needCloseButton {
            let closeButton = PizzaButton(primaryAction: .init(handler: { [weak self] _ in
                self?.onClose?()
            }))
            closeButton.setImage(
                UIImage(
                    systemSymbol: .xmarkCircleFill,
                    withConfiguration: UIImage.SymbolConfiguration(
                        hierarchicalColor: .palette.labelSecondary
                    ).applying(UIImage.SymbolConfiguration(pointSize: 22))
                ),
                for: []
            )
            addSubview(closeButton)
            closeButton.tintColor = .systemGray4
            closeButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.size.equalTo(60)
            }
        }

        self.do {
            $0.backgroundColor = .palette.backgroundTertiary
            $0.layer.cornerCurve = .continuous
            $0.layer.cornerRadius = 20
        }
    }

}

private class WrapperController: PizzaController {

    private let child: UIViewController
    private let needCloseButton: Bool
    private let onClose: PizzaEmptyClosure?

    init(
        child: UIViewController,
        needCloseButton: Bool,
        onClose: PizzaEmptyClosure?
    ) {
        self.child = child
        self.needCloseButton = needCloseButton
        self.onClose = onClose
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.do {
            $0.backgroundColor = .palette.backgroundTertiary
            $0.layer.cornerCurve = .continuous
            $0.layer.cornerRadius = 20
        }

        addChild(child)
        child.view.do {
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        child.didMove(toParent: self)

        if needCloseButton {
            let closeButton = PizzaButton(primaryAction: .init(handler: { [weak self] _ in
                self?.onClose?()
            }))
            closeButton.setImage(
                UIImage(
                    systemSymbol: .xmarkCircleFill,
                    withConfiguration: UIImage.SymbolConfiguration(
                        hierarchicalColor: .palette.labelSecondary
                    ).applying(UIImage.SymbolConfiguration(pointSize: 22))
                ),
                for: []
            )
            view.addSubview(closeButton)
            closeButton.tintColor = .systemGray4
            closeButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview()
                make.size.equalTo(60)
            }
        }
    }

}
