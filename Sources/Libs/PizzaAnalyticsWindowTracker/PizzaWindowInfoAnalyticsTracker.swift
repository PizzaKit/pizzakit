import UIKit
import PizzaKit
import SnapKit
import Combine
import AnyAnalytics

public class PizzaWindowsInfoAnalyticsView: PizzaView {

    private enum Status {
        case identifiersEqual
        case identifiersAreNotEqual
        case noIdentifierForTopController
    }

    private let label = PizzaLabel()
    private let statusView = UIView()

    public override func commonInit() {
        super.commonInit()

        label.do {
            addSubview($0)
            $0.style = .allStyles.caption2(
                color: .palette.labelSecondary,
                alignment: .right
            )
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                    .inset(UIEdgeInsets(horizontal: 7, vertical: 3))
                    .inset(UIEdgeInsets(top: 3, left: 7, bottom: 3, right: 12))
            }
            $0.alpha = 0.5
        }

        statusView.do {
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-4)
                make.centerY.equalToSuperview()
                make.size.equalTo(6)
            }
            $0.layer.cornerRadius = 3
        }

        layer.cornerRadius = 4
        isUserInteractionEnabled = false
        backgroundColor = .systemGray5
    }

    public func configure(
        timerIdentifier: String?,
        trackedIdentifier: String?
    ) {
        if timerIdentifier == nil || trackedIdentifier == nil {
            statusView.backgroundColor = .systemRed
            if let timerIdentifier {
                label.text = "t:\(timerIdentifier)"
            } else if let trackedIdentifier {
                label.text = "a:\(trackedIdentifier)"
            } else {
                label.text = "---"
            }
        } else if timerIdentifier == trackedIdentifier {
            statusView.backgroundColor = .systemGreen
            label.text = timerIdentifier
        } else {
            statusView.backgroundColor = .systemYellow
            label.text = "t:\(timerIdentifier!)-a:\(trackedIdentifier!)"
        }
    }

}

public protocol PizzaWindowAnalyticsScreenNameExtractor {
    func extract(name: String, parameters: [String: Any]) -> String?
}

public class PizzaWindowInfoAnalyticsTracker: AnalyticsProvider {

    private struct State {
        var timerIdentifier: String?
        var analyticsIdentifier: String?
    }

    // MARK: - Private Methods

    private let view = PizzaWindowsInfoAnalyticsView()
    private let window: UIWindow

    private let analyticsDebugService: PizzaAnalyticsDebugService
    private let extractor: PizzaWindowAnalyticsScreenNameExtractor

    private var state: State {
        get {
            stateSubject.value
        }
        set {
            stateSubject.send(newValue)
        }
    }
    private var stateSubject = CurrentValueSubject<State, Never>(State())

    private var bag = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        scene: UIWindowScene,
        analyticsDebugService: PizzaAnalyticsDebugService,
        extractor: PizzaWindowAnalyticsScreenNameExtractor
    ) {
        self.analyticsDebugService = analyticsDebugService
        self.extractor = extractor

        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        let newWindow = UIWindow(windowScene: scene)
        newWindow.windowLevel = .statusBar
        newWindow.isUserInteractionEnabled = false
        newWindow.rootViewController = controller
        self.window = newWindow

        view.do {
            controller.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top
                    .equalTo(controller.view.safeAreaLayoutGuide.snp.top)
                    .inset(4)
                make.trailing
                    .equalTo(controller.view.safeAreaLayoutGuide.snp.trailing)
                    .inset(10)
            }
        }

        analyticsDebugService
            .onVisibilityChangedPublisher
            .withCurrentValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                self?.window.isHidden = !isVisible
            }
            .store(in: &bag)

        Timer.publish(every: 0.3, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.checkController()
            }
            .store(in: &bag)

        stateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.view.configure(
                    timerIdentifier: state.timerIdentifier,
                    trackedIdentifier: state.analyticsIdentifier
                )
            }
            .store(in: &bag)
    }

    private var topViewController: UIViewController? {
        return UIApplication.topViewController(UIApplication.keyWindow?.rootViewController)
    }

    private func checkController() {
        guard
            let controller = topViewController,
            let screenName = PizzaControllerScreenNameHolder.shared.read(controller: controller)
        else {
            self.state.timerIdentifier = nil
            return
        }
        self.state.timerIdentifier = screenName
    }

    // MARK: - AnalyticsProvider

    public func trackEvent(name: String, parameters: [String: Any]) {
        if let extracted = extractor.extract(name: name, parameters: parameters) {
            self.state.analyticsIdentifier = extracted
        }
    }

    public func setUserProperty(name: String, value: String) {}

    public func setUserId(_ id: String) {}

}
