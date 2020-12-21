//
//  InstancesProvider.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol InstancesProviderProtocol {
    func fetchCachedInstances() -> AnyPublisher<[Instance], Never>
    
    func delete(_ instance: Instance) -> AnyPublisher<(), Never>
}

class InstancesProvider: InstancesProviderProtocol {
    
    private let instancesPersistenceService: InstancePersistenceServiceProtocol
    
    init(
        instancesPersistenceService: InstancePersistenceServiceProtocol
    ) {
        self.instancesPersistenceService = instancesPersistenceService
    }
    
    func fetchCachedInstances() -> AnyPublisher<[Instance], Never> {
        
        Future<[Instance], Never> { promise in
            
            let instances = Instance.getAllInstances()
            promise(.success(instances))
            
        }.eraseToAnyPublisher()
        
    }
    
    func delete(_ instance: Instance) -> AnyPublisher<(), Never> {
        
        Future<(), Never> { promise in
            CoreDataHelper.shared.deleteFromStore(instance, save: true)
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
}
