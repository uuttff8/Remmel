//
//  InstancePersistenceService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import CoreData
import Foundation
import Combine

protocol InstancePersistenceServiceProtocol: AnyObject {
    func fetch(ids: [Instance.ID]) -> AnyPublisher<[Instance], Never>
    func fetch(id: Instance.ID) -> AnyPublisher<Instance?, Never>
    
    func getAllInstances() -> AnyPublisher<[Instance], Never>
}

final class InstancePersistenceService: InstancePersistenceServiceProtocol {
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext = CoreDataHelper.shared.context) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getAllInstances() ->  AnyPublisher<[Instance], Never> {
        Future<[Instance], Never> { promise in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Instance.self))
            let predicate = NSPredicate(value: true)
            request.predicate = predicate
            do {
                let results = try CoreDataHelper.shared.context.fetch(request) as! [Instance]
                promise(.success(results))
            } catch {
                Logger.commonLog.error("Error while getting all videos from CoreData")
                return promise(.success([]))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetch(id: Instance.ID) -> AnyPublisher<Instance?, Never> {
        fetchUsers(ids: [id])
            .map({ $0.first })
            .eraseToAnyPublisher()
    }
    
    func fetch(ids: [Instance.ID]) -> AnyPublisher<[Instance], Never> {
        fetchUsers(ids: ids)
    }
    
    private func fetchUsers(ids: [Instance.ID]) -> AnyPublisher<[Instance], Never> {
        Future<[Instance], Never> { promise in
            
            let idSubpredicates = ids.map { id in
                NSPredicate(format: "%K == %@", #keyPath(Instance.managedLabel), id)
            }
            let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: idSubpredicates)

            let request: NSFetchRequest<Instance> = Instance.fetchRequest
            request.predicate = compoundPredicate
            request.sortDescriptors = Instance.defaultSortDescriptors
            request.returnsObjectsAsFaults = false

            self.managedObjectContext.performAndWait {
                do {
                    let users = try self.managedObjectContext.fetch(request)
                    promise(.success(users))
                } catch {
                    Logger.commonLog.info("Error while fetching users = \(ids)")
                    promise(.success([]))
                }
            }
        }.eraseToAnyPublisher()
    }

}
