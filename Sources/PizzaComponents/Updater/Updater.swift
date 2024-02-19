import UIKit
import PizzaCore

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
    var onScrollViewDidScroll: PizzaClosure<Target>? { get set }

    func initialize(target: Target)
    func performUpdates(target: Target, sections: [ComponentSection])
    
    @available(*, deprecated, renamed: "getCell(target:componentId:)")
    func getCell(
        tableView: Target,
        componentId: AnyHashable
    ) -> UIView?
    
    func getCell(
        target: Target,
        componentId: AnyHashable
    ) -> UIView?
}
