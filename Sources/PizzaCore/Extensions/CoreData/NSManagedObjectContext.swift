import CoreData

extension NSManagedObjectContext {

    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard
            let object = NSEntityDescription.insertNewObject(
                forEntityName: A.entityName,
                into: self
            ) as? A
        else {
            fatalError("Wrong object type")
        }
        return object
    }

    @discardableResult
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    func performChanges(
        block: @escaping PizzaClosure<NSManagedObjectContext>,
        completion: PizzaEmptyClosure? = nil
    ) {
        perform {
            block(self)
            self.saveOrRollback()
            completion?()
        }
    }

}
