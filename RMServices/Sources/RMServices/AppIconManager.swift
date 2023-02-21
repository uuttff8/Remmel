//
//  AppIconManager.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

public protocol AppIconManagerProtocol: AnyObject {
    var current: LemmyAppIcon { get }
    var availableIcons: [LemmyAppIcon] { get }

    @MainActor
    func setIcon(_ appIcon: LemmyAppIcon) async
}

public enum LemmyAppIcon: String, CaseIterable {
    case white = "whiteIcon"
    case black = "blackIcon"
    
    var name: String? {
        switch self {
        case .white: return nil
        case .black: return "blackIcon"
        }
    }
}

public class AppIconManager: AppIconManagerProtocol {
    public init() {}
    
    public var current: LemmyAppIcon {
        LemmyAppIcon.allCases.first(where: { $0.name == UIApplication.shared.alternateIconName }) ?? .white
    }
    
    public var availableIcons: [LemmyAppIcon] {
        LemmyAppIcon.allCases
    }

    @MainActor
    public func setIcon(_ appIcon: LemmyAppIcon) async {
        guard current != appIcon, UIApplication.shared.supportsAlternateIcons else {
            return
        }

        do {
            try await UIApplication.shared.setAlternateIconName(appIcon.name)
        } catch {
            debugPrint("Error setting alternate icon \(appIcon.name ?? "white"): \(error.localizedDescription)")
        }
    }
}
