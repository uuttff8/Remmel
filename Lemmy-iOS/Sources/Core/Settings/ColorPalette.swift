//
//  ColorPalette.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var navControllerSeparator: UIColor {
        .dynamic(
            light: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1),
            dark: .separator
        )
    }
    
    static var lemmyAccent: UIColor {
        .dynamic(
            light: UIColor.label,
            dark: UIColor.label
        )
    }
    
    static var lemmyCommunity: UIColor {
        .dynamic(
            light: .init(rgb: 0xFFE95420, alphaVal: 1),
            dark: .init(rgb: 0xFF00bc8c, alphaVal: 1)
        )
    }
    
    static var lemmyLabel: UIColor {
        .dynamic(
            light: .init(rgb: 0xFF303030, alphaVal: 1),
            dark: .init(rgb: 0xFFdee2e6, alphaVal: 1)
        )
    }
    
    static var lemmySecondLabel: UIColor {
        .dynamic(
            light: UIColor.init(red: 134/255, green: 142/255, blue: 150/255, alpha: 1),
            dark: UIColor.init(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)
        )
    }
    
    static var lemmyBlue: UIColor {
        .dynamic(
            light: .init(rgb: 0xFF3498db, alphaVal: 1),
            dark: .init(rgb: 0xFF3498db, alphaVal: 1)
        )
    }
}
