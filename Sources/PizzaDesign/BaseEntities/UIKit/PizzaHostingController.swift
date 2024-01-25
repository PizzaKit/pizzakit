import SwiftUI
import UIKit
import PizzaCore

open class PizzaHostingController<Content>: UIHostingController<Content>, PizzaLifecycleObservableController where Content: View {

    // MARK: - Properties

    private var onDidAppearClosures: [PizzaEmptyClosure] = []
    private var onWillAppearClosures: [PizzaEmptyClosure] = []
    private var onWillDisappearClosures: [PizzaEmptyClosure] = []
    private var onDidDisappearClosures: [PizzaEmptyClosure] = []
    private var onDidLoadClosures: [PizzaEmptyClosure] = []

    // MARK: - UIViewController

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onDidAppearClosures.forEach { $0() }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onWillAppearClosures.forEach { $0() }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onWillDisappearClosures.forEach { $0() }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDidDisappearClosures.forEach { $0() }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        onDidLoadClosures.forEach { $0() }
    }

    // MARK: - PizzaLifecycleObservableController

    public func onDidAppear(completion: @escaping PizzaEmptyClosure) {
        onDidAppearClosures.append(completion)
    }

    public func onWillAppear(completion: @escaping PizzaEmptyClosure) {
        onWillAppearClosures.append(completion)
    }

    public func onWillDisappear(completion: @escaping PizzaEmptyClosure) {
        onWillDisappearClosures.append(completion)
    }

    public func onDidDisappear(completion: @escaping PizzaEmptyClosure) {
        onDidDisappearClosures.append(completion)
    }

    public func onDidLoad(completion: @escaping PizzaEmptyClosure) {
        onDidLoadClosures.append(completion)
    }

}
