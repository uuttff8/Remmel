//
//  AppIconManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

enum LemmyAppIcon: String, CaseIterable {
    static var `default` = "whiteIcon"
    
    case white = "whiteIcon"
    case black = "blackIcon"
    
    var name: String? {
        switch self {
        case .white:
            return nil
        case .black:
            return "blackIcon"
        }
    }
}

protocol AppIconManagerProtocol: AnyObject {
    var current: LemmyAppIcon { get }
    
    var availableIcons: [LemmyAppIcon] { get }
    
    func setIcon(_ appIcon: LemmyAppIcon, completion: ((Bool) -> Void)?)
}

class AppIconManager: AppIconManagerProtocol {
    var current: LemmyAppIcon {
        LemmyAppIcon.allCases.first(where: {
            $0.name == UIApplication.shared.alternateIconName
        }) ?? .white
    }
    
    var availableIcons: [LemmyAppIcon] { LemmyAppIcon.allCases }
    
    func setIcon(_ appIcon: LemmyAppIcon, completion: ((Bool) -> Void)?) {
        guard current != appIcon,
              UIApplication.shared.supportsAlternateIcons
        else { return }
        
        UIApplication.shared.setAlternateIconName(appIcon.name) { error in
            if let error = error {
                print("Error setting alternate icon \(appIcon.name ?? ""): \(error.localizedDescription)")
            }
            completion?(error != nil)
        }
    }
}
