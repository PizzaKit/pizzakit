import Foundation

open class PizzaDebouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue

    public init(
        delay: TimeInterval,
        queue: DispatchQueue = DispatchQueue.main
    ) {
        self.delay = delay
        self.queue = queue
    }
    open func debounce(action: @escaping (() -> Void)) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    open func cancel() {
        workItem?.cancel()
    }
}
