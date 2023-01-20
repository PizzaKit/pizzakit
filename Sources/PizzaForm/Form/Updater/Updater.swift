public protocol Updater<Target> {
    associatedtype Target

    func initialize(target: Target)
    func performUpdates(target: Target, data: [Section])
}
