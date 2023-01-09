import Foundation
import CoreData
import PizzaCore

open class PizzaCoreDataService: NSObject {

    // MARK: - Static Properties

    open var viewContext: NSManagedObjectContext {
        persistenContaner.viewContext.do {
            $0.automaticallyMergesChangesFromParent = true
            $0.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }

    // MARK: - Private Properties

    private let dataModelName: String

    // MARK: - Initialization

    public init(dataModelName: String) {
        self.dataModelName = dataModelName
        super.init()
    }

    // MARK: - Properties

    lazy open var persistenContaner: NSPersistentContainer = {
        NSPersistentCloudKitContainer(name: dataModelName).do {
            $0.loadPersistentStores { (description, error) in
                guard let error = error as NSError? else { return }
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }()

    // MARK: - Methods

    open func createBackgroundContext() -> NSManagedObjectContext {
        persistenContaner.newBackgroundContext()
    }

    open func save(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            #if DEBUG
            fatalError("Unresolved error \(error), \(error.userInfo)")
            #else
            print("Unresolved error \(error), \(error.userInfo)")
            #endif
        }
    }

}
