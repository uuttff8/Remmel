//
//  AppIconManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol AppIconManagerProtocol: AnyObject {
    var current: LemmyAppIcon { get }
    var availableIcons: [LemmyAppIcon] { get }

    func setIcon(_ appIcon: LemmyAppIcon, completion: ((Bool) -> Void)?)
}

enum LemmyAppIcon: String, CaseIterable {
    case white = "whiteIcon"
    case black = "blackIcon"
    
    var name: String {
        switch self {
        case .white: return "whiteIcon"
        case .black: return "blackIcon"
        }
    }
}

class AppIconManager: AppIconManagerProtocol {
    var current: LemmyAppIcon {
        LemmyAppIcon.allCases.first(where: { $0.name == UIApplication.shared.alternateIconName }) ?? .white
    }
    
    var availableIcons: [LemmyAppIcon] {
        LemmyAppIcon.allCases
    }
    
    func setIcon(_ appIcon: LemmyAppIcon, completion: ((Bool) -> Void)?) {
        guard current != appIcon, UIApplication.shared.supportsAlternateIcons else {
            return
        }
        
        UIApplication.shared.setAlternateIconName(appIcon.name) { error in
            if let error = error {
                Logger.common.error("Error setting alternate icon \(appIcon.name): \(error.localizedDescription)")
            }
            completion?(error != nil)
        }
    }
}
