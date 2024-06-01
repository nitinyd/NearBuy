//
//  VenuePersistentStorage.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import Foundation
import CoreData

final class VenuePersistentStorage {
    static let shared = VenuePersistentStorage()
    private init() {}
    
    lazy var context = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NearBuy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension VenuePersistentStorage {
    static func performOnBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        VenuePersistentStorage.shared.persistentContainer.performBackgroundTask(block)
    }
}
