//
//  ContentPreferencesStorageManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol ContentPreferencesStorageManagerProtocol: AnyObject {
    var contentSortType: LemmySortType { get set }
    var listingType: LemmyListingType { get set }
}

final class ContentPreferencesStorageManager: ContentPreferencesStorageManagerProtocol {
    private enum Key: String {
        case contentSortType = "contentSortTypeKey"
        case listingType = "listingTypeKey"
    }
    
    var contentSortType: LemmySortType {
        get {
            if let stringValue = UserDefaults.appShared.string(forKey: Key.contentSortType.rawValue),
               let sortType = LemmySortType(rawValue: stringValue) {
                return sortType
            } else {
                return .active
            }
        }
        set {
            UserDefaults.appShared.set(newValue.rawValue, forKey: Key.contentSortType.rawValue)
        }
    }
    
    var listingType: LemmyListingType {
        get {
            if let stringValue = UserDefaults.appShared.string(forKey: Key.listingType.rawValue),
               let listingType = LemmyListingType(rawValue: stringValue) {
                return listingType
            }
            
            return .all
        }
        set {
            UserDefaults.appShared.set(newValue.rawValue, forKey: Key.listingType.rawValue)
        }
    }
}
