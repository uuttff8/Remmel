//
//  UIColor+Ext.swift
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
    
    convenience init(rgb: UInt, alphaVal: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alphaVal
        )
    }
}
