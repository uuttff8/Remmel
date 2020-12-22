//
//  Instance+CoreDataClass.swift
//  
//
//  Created by uuttff8 on 20.12.2020.
//
//

import Foundation
import CoreData

@objc(Instance)
public class Instance: NSManagedObject, Codable, Identifiable {
        
    public var id: String {
        get { return label }
        set { label = newValue }
    }
    
    enum CodingKeys: String, CodingKey {
        case label
        case iconUrl = "icon"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext
        else { fatalError() }
        
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Instance.self), in: context)
        else { fatalError() }

        self.init(entity: entity, insertInto: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decode(String.self, forKey: .label)
        self.iconUrl = try container.decode(String.self, forKey: .iconUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(label, forKey: .label)
        try container.encode(iconUrl, forKey: .iconUrl)
    }
    
    static func getAllInstances() -> [Instance] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Instance.self))
        let predicate = NSPredicate(value: true)
        request.predicate = predicate
        do {
            let results = try CoreDataHelper.shared.context.fetch(request)
            return results as! [Instance]
        } catch {
            print("Error while getting videos")
            return []
        }
    }
}
