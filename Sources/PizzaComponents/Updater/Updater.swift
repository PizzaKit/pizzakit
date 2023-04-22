/// Entity for managing Target collection and perform updates
public protocol Updater<Target> {
    associatedtype Target

    func initialize(target: Target)
    func performUpdates(target: Target, sections: [ComponentSection])
}
