import CoreData

public extension NSManagedObjectContext {

    // TODO: remove
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

    enum CreationError: Error {
        case errorInSaving, blockReturnsNil
    }

    // TODO: change naming
    func createObject<ManagedObject: NSManagedObject>(
        block: @escaping PizzaReturnClosure<NSManagedObjectContext, ManagedObject?>,
        completion: PizzaClosure<Result<ManagedObject, Error>>? = nil
    ) {
        perform {
            let object = block(self)
            if let object {
                if self.saveOrRollback() {
                    completion?(.success(object))
                } else {
                    completion?(.failure(CreationError.errorInSaving))
                }
            } else {
                completion?(.failure(CreationError.blockReturnsNil))
            }
        }
    }

}
