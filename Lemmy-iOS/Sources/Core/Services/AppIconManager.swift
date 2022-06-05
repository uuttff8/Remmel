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

    @MainActor
    func setIcon(_ appIcon: LemmyAppIcon) async
}

enum LemmyAppIcon: String, CaseIterable {
    case white = "whiteIcon"
    case black = "blackIcon"
    
    var name: String? {
        switch self {
        case .white: return nil
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

    @MainActor
    func setIcon(_ appIcon: LemmyAppIcon) async {
        guard current != appIcon, UIApplication.shared.supportsAlternateIcons else {
            return
        }

        do {
            try await UIApplication.shared.setAlternateIconName(appIcon.name)
        } catch {
            Logger.common.error("Error setting alternate icon \(appIcon.name ?? "white"): \(error.localizedDescription)")
        }
    }
}
