//
//  CoreDataStack.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 17.05.2021.
//

import CoreData
import Foundation

final class CoreDataStack: DatabaseServiceProtocol {
    var didUpdateDatabase: ((CoreDataStack) -> Void)?

    private var storeURL: URL = {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Documents path not found")
        }

        return documentsURL.appendingPathComponent("Movies.sqlite")
    }()

    private let dataModelName = "Movies"
    private let dataModelExtension = "momd"

    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)
        else {
            fatalError("Model path not found")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Managed object model can not be created")
        }

        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: self.storeURL,
                options: nil
            )
        } catch {
            fatalError(error.localizedDescription)
        }

        return coordinator
    }()

    // MARK: - Contexts

    private lazy var writerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writerContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()

    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }

    // MARK: - Public Methods

    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)

            if context.hasChanges {
                do {
                    try performSave(in: context)
                } catch { assertionFailure(error.localizedDescription) }
            }
        }
    }

    func executeFetchRequest<T>(_ request: NSFetchRequest<T>) -> [T]? where T: NSFetchRequestResult {
        let context = saveContext()
        let result = try? context.fetch(request)
        return result
    }

    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(managedObjectContextObjectsDidChange(notification:)),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: mainContext
        )
    }

    func printDatabaseStatistics() {
        mainContext.perform {
            do {
                // TODO: Uncomment
//                let count = try self.mainContext.count(for: Movie.fetchRequest())
//                print("\(count) пользователей")
//                let array = try self.mainContext.count(for: Movie.fetchRequest()) as? [User] ?? []
//                array.forEach {
//                    print($0.about)
//                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    // MARK: - Private Methods

    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        didUpdateDatabase?(self)

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            print("Добавлено объектов: \(inserts.count)")
        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            print("Обновлено объектов: \(updates.count)")
        }

        if let deletions = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletions.count > 0 {
            print("Удалено объектов: \(deletions.count)")
        }
    }

    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent { try performSave(in: parent) }
    }
}
