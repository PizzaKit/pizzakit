import UIKit

public struct UpdateMoveContext {
    public let section: ComponentSection
    public let index: Int
}

public protocol UpdaterDelegate {

    func canMoveComponent(in section: ComponentSection) -> Bool
    func moveComponent(from: UpdateMoveContext, to: UpdateMoveContext)

}

/// Entity for managing Target collection and perform updates
public protocol Updater<Target> {
    associatedtype Target

    var updaterDelegate: UpdaterDelegate? { get set }

    func initialize(target: Target)
    func performUpdates(target: Target, sections: [ComponentSection])
    func getCell(
        tableView: Target,
        componentId: AnyHashable
    ) -> UIView?
}
