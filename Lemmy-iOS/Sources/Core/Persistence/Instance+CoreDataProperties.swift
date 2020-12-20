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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instance> {
        return NSFetchRequest<Instance>(entityName: "Instance")
    }

    @NSManaged public var managedLabel: String?
    
    var label: String {
        get { self.managedLabel ?? "No label" }
        set { self.managedLabel = newValue }
    }

}
