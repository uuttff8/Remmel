//
//  ContentPreferencesStorageManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMModels

public protocol ContentPreferencesStorageManagerProtocol: AnyObject {
    var contentSortType: RMModels.Others.SortType { get set }
    var listingType: RMModels.Others.ListingType { get set }
}

public final class ContentPreferencesStorageManager: ContentPreferencesStorageManagerProtocol {
    private enum Key: String {
        case contentSortType = "contentSortTypeKey"
        case listingType = "listingTypeKey"
    }
    
    public init() {}
    
    public var contentSortType: RMModels.Others.SortType {
        get {
            if let stringValue = UserDefaults.authShared.string(forKey: Key.contentSortType.rawValue),
               let sortType = RMModels.Others.SortType(fromStr: stringValue) {
                return sortType
            } else {
                return .active
            }
        }
        set {
            UserDefaults.authShared.set(newValue.rawValue, forKey: Key.contentSortType.rawValue)
        }
    }
    
    public var listingType: RMModels.Others.ListingType {
        get {
            if let stringValue = UserDefaults.authShared.string(forKey: Key.listingType.rawValue),
               let listingType = RMModels.Others.ListingType(rawValue: stringValue) {
                return listingType
            }
            
            return .all
        }
        set {
            UserDefaults.authShared.set(newValue.rawValue, forKey: Key.listingType.rawValue)
        }
    }
}
