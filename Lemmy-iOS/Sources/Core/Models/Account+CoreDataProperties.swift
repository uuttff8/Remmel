//
//  Account+CoreDataProperties.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//
//

import Foundation
import CoreData

extension Account {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(key: #keyPath(managedName), ascending: false)]
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: String(describing: Account.self))
    }

    @NSManaged public var managedName: String?
    @NSManaged public var managedPass: String?
}

extension Account {
    
    var name: String {
        get { self.managedName ?? "No name" }
        set { self.managedName = newValue }
    }
    
    var pass: String {
        get { self.managedPass ?? "" }
        set { self.managedPass = newValue }
    }
}
