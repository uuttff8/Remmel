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
        [NSSortDescriptor(key: #keyPath(managedLogin), ascending: false)]
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: String(describing: Account.self))
    }

    @NSManaged public var managedLogin: String?
    @NSManaged public var managedPassword: String?
}

extension Account {
    
    var login: String {
        get { self.managedLogin ?? "No Login" }
        set { self.managedLogin = newValue }
    }
    
    var password: String {
        get { self.managedPassword ?? "No password" }
        set { self.managedPassword = newValue }
    }
}
