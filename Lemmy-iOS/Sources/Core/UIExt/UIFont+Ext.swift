//
//  UIFont+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIFont {
    
    func monospaceNumberFeatures() -> UIFont {
        let fontFeatures: [[UIFontDescriptor.FeatureKey: Int]] = [
            [.featureIdentifier: kNumberSpacingType, .typeIdentifier: kMonospacedNumbersSelector],
            [.featureIdentifier: kNumberCaseType, .typeIdentifier: kUpperCaseNumbersSelector]
        ]
        fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings: fontFeatures])
        
        return UIFont(descriptor: fontDescriptor, size: pointSize)
    }
}


extension UIFont {
    var monospacedDigitFont: UIFont {
        let newFontDescriptor = fontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                                              UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings]
        let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }
}

