import CoreData

public protocol PizzaManaged: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

public extension PizzaManaged {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        []
    }

    static var sortedFetchedRequest: NSFetchRequest<Self> {
        NSFetchRequest<Self>(entityName: entityName).do {
            $0.sortDescriptors = defaultSortDescriptors
        }
    }

    static func sortedFetchedRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        sortedFetchedRequest.do {
            $0.predicate = predicate
        }
    }

}

public extension PizzaManaged where Self: NSManagedObject {

    static var entityName: String {
        entity().name!
    }

    static func fetch(
        in context: NSManagedObjectContext,
        configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }
    ) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: entityName)
        configurationBlock(request)
        return (try? context.fetch(request)) ?? []
    }

    @discardableResult
    static func findOrCreate(
        in context: NSManagedObjectContext,
        matching predicate: NSPredicate?,
        configure: (Self) -> Void
    ) -> Self {
        guard
            let predicate,
            let object = findOrFetch(in: context, matching: predicate)
        else {
            let newObject: Self = context.insertObject()
            configure(newObject)
            return newObject
        }
        configure(object)
        return object
    }

    static func findOrFetch(
        in context: NSManagedObjectContext,
        matching predicate: NSPredicate
    ) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }

    static func materializedObject(
        in context: NSManagedObjectContext,
        matching predicate: NSPredicate
    ) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }

}

extension PizzaManaged where Self: NSManagedObject {

    func set<Value>(_ value: Value, for keyPath: ReferenceWritableKeyPath<Self, Value>) {
        setValue(value, forKey: keyPath.toString)
    }
}

fileprivate extension ReferenceWritableKeyPath where Root: NSObject {

    var toString: String {
        return NSExpression(forKeyPath: self).keyPath
    }

}
