//
//  FormatterHelper.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

enum FormatterHelper {
    static func humanReadableAppIconName(appIcon: LemmyAppIcon) -> String {
        switch appIcon {
        case .white:
            return "White"
        case .black:
            return "Black"
        }
    }
    
    static func removeImageTag(fromMarkdown md: String) -> String {
        return md.replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
}
