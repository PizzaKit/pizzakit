import UIKit
import SwiftUI
import PizzaKit
import SnapKit
import SFSafeSymbols

public protocol PizzaOnboardingControllerDelegate: AnyObject {
    func completed()
    func skip()
    func moduleWasDeallocated()
}

open class PizzaOnboardingController: PizzaController {

    private let hostingController: UIHostingController<OnboardingScreenView>
    private weak var delegate: PizzaOnboardingControllerDelegate?

    public init(
        config: PizzaOnboardingConfig,
        delegate: PizzaOnboardingControllerDelegate?
    ) {
        var onCompletedPress: PizzaEmptyClosure?
        var onSkipPress: PizzaEmptyClosure?
        let view = OnboardingScreenView(
            config: config,
            onCompleted: {
                onCompletedPress?()
            },
            onSkip: {
                onSkipPress?()
            }
        )
        self.hostingController = .init(
            rootView: view
        )
        self.delegate = delegate
        super.init()

        onCompletedPress = { [weak self] in
            self?.delegate?.completed()
        }
        onSkipPress = { [weak self] in
            self?.delegate?.skip()
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        delegate?.moduleWasDeallocated()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hostingController.didMove(toParent: self)
    }

}
