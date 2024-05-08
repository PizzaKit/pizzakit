import Foundation
import CoreData

public extension Notification {
    var insertedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .insertedObjects)
    }
    var updatedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .updatedObjects)
    }
    var deletedObjects: Set<NSManagedObject>? {
        return userInfo?.value(for: .deletedObjects)
    }
}

private extension Dictionary where Key == AnyHashable {
    func value<T>(for key: NSManagedObjectContext.NotificationKey) -> T? {
        return self[key.rawValue] as? T
    }
}
