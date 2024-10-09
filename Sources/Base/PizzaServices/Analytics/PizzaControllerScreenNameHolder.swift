import UIKit

public class PizzaControllerScreenNameHolder {

    private struct WeakItem {
        weak var controller: UIViewController?
        let screenTypeRaw: String
    }

    private var storage: [WeakItem] = []

    public static let shared = PizzaControllerScreenNameHolder()

    public func store(controller: UIViewController, screenTypeRaw: String) {
        storage.append(.init(controller: controller, screenTypeRaw: screenTypeRaw))
    }

    public func read(controller: UIViewController) -> String? {
        storage
            .first(where: { $0.controller === controller })?
            .screenTypeRaw
    }

    private func removeUnused() {
        storage.removeAll { $0.controller == nil }
    }

}
