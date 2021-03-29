//
//  AccountsPersistenceService.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import CoreData
import Combine

protocol AccountsPersistenceServiceProtocol: AnyObject {
    func getAllAccounts() -> AnyPublisher<[Account], Never>
    func delete(_ account: Account) -> AnyPublisher<(), Never>
}

final class AccountsPersistenceService: AccountsPersistenceServiceProtocol {
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext = CoreDataHelper.shared.context) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getAllAccounts() -> AnyPublisher<[Account], Never> {
        Future<[Account], Never> { promise in
            let request = Account.fetchRequest()
            let predicate = NSPredicate(value: true)
            request.predicate = predicate
            do {
                let results = try self.managedObjectContext.fetch(request) as! [Account]
                promise(.success(results))
            } catch {
                Logger.common.error("Error while getting all accounts from CoreData")
                return promise(.success([]))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(_ account: Account) -> AnyPublisher<(), Never> {
        Future<(), Never> { promise in
            CoreDataHelper.shared.deleteFromStore(account, save: true)
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
