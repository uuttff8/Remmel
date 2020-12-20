//
//  Instance+CoreDataProperties.swift
//  
//
//  Created by uuttff8 on 20.12.2020.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")!
}

extension Instance {
    
    static var fetchRequest: NSFetchRequest<Instance> {
        NSFetchRequest<Instance>(entityName: String(describing: Instance.self))
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(managedLabel), ascending: false)]
    }

    @NSManaged public var managedLabel: String?
    @NSManaged public var managedIconUrl: String?
    
    var label: String {
        get { self.managedLabel ?? "No label" }
        set { self.managedLabel = newValue }
    }
    
    var iconUrl: String {
        get { self.managedLabel ?? "No icon" }
        set { self.managedLabel = newValue }
    }

}
