//
//  Instance+CoreDataProperties.swift
//  
//
//  Created by uuttff8 on 20.12.2020.
//
//

import Foundation
import CoreData

extension Instance {
    
    static var fetchRequest: NSFetchRequest<Instance> {
        NSFetchRequest<Instance>(entityName: String(describing: Instance.self))
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(managedLabel), ascending: false)]
    }
    
    @NSManaged public var managedLabel: String?
    @NSManaged public var managedIconUrl: String?
    @NSManaged public var managedAccounts: Set<Account>?
}

// Swift wrapper
extension Instance {
    var label: String {
        get { self.managedLabel ?? "No label" }
        set { self.managedLabel = newValue }
    }
    
    var iconUrl: String {
        get { self.managedLabel ?? "No icon" }
        set { self.managedLabel = newValue }
    }
    
    var accounts: [Account] {
        Array(self.managedAccounts!)
    }
    
    func addAccountItemsObject(value: Account) {
        self.managedAccounts?.insert(value)
    }
    
    @NSManaged public func removeAccountItemsObject(value: Account)
    @NSManaged public func addAccountItems(values: Set<Account>)
    @NSManaged public func removeAccountItems(values: Set<Account>)
}
