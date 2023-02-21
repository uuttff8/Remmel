//
//  ColorPalette.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIColor {
    /// Create a UIColor with different colors for light and dark mode, and with a normal/high contrast level.
    /// Fallbacks to light color on earlier versions.
    /// - Parameters:
    ///   - light: Color to use in light/unspecified mode.
    ///   - dark: Color to use in dark mode.
    ///   - lightAccessibility: Color to use in light/unspecified mode and with a high contrast level.
    ///   - darkAccessibility: Color to use in dark mode and with a high contrast level.
    static func dynamic(
        light: UIColor,
        dark: UIColor,
        lightAccessibility: UIColor? = nil,
        darkAccessibility: UIColor? = nil
    ) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch(traitCollection.userInterfaceStyle, traitCollection.accessibilityContrast) {
                case (.dark, .high):
                    return darkAccessibility ?? dark
                case (.dark, _):
                    return dark
                case (_, .high):
                    return lightAccessibility ?? light
                default:
                    return light
                }
            }
        } else {
            return light
        }
    }
}

extension UIColor {
    convenience init(rgb: UInt, alphaVal: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alphaVal
        )
    }
}

extension UIColor {
    
    static var navControllerSeparator: UIColor {
        .dynamic(
            light: UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1),
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
            light: UIColor(red: 134 / 255, green: 142 / 255, blue: 150 / 255, alpha: 1),
            dark: UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)
        )
    }
    
    static var lemmyBlue: UIColor {
        .dynamic(
            light: .init(rgb: 0xFF3498db, alphaVal: 1),
            dark: .init(rgb: 0xFF3498db, alphaVal: 1)
        )
    }
}
