//
//  CoreDataManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataHelper: NSObject {
    static var shared = CoreDataHelper()

    private(set) var coordinator: NSPersistentStoreCoordinator
    private(set) var model: NSManagedObjectModel
    private(set) var context: NSManagedObjectContext
    private(set) var storeURL: URL
        
    private let lockQueue = DispatchQueue(label: "com.test.LockQueue", attributes: [])

    override private init() {
        let modelURL = Bundle.main.url(forResource: "LemmyCoreData", withExtension: "momd")!
        self.model = NSManagedObjectModel(contentsOf: modelURL)!

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        self.storeURL = documentsDirectory.appendingPathComponent("base.sqlite")

        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)

        do {
            _ = try self.coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: self.storeURL,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true,
                    "WAL": "journal_mode"
                ]
            )
        } catch {
            Logger.commonLog.emergency("Application's NSPersistentStore is nil, abort")
            abort()
        }

        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.coordinator

        super.init()
    }

    func save() {
        self.lockQueue.sync { [weak self] in
            self?.context.perform({ [weak self] in
                do {
                    try self?.context.save()
                } catch {
                    Logger.commonLog.emergency("Saving error in coredata")
                    print("SAVING ERROR")
                }
            })
        }
    }

    func deleteFromStore(_ object: NSManagedObject, save shouldSave: Bool = true) {
        self.lockQueue.sync { [weak self] in
            self?.context.perform({ [weak self] in
                self?.context.delete(object)
                if shouldSave == true {
                    self?.save()
                }
            })
        }
    }
}
