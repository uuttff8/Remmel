//
//  UILabel+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// https://stackoverflow.com/a/53087984
extension UILabel {
    var isTruncated: Bool {
        layoutIfNeeded()

        let rectBounds = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        var fullTextHeight: CGFloat?

        if attributedText != nil {
            fullTextHeight = attributedText?.boundingRect(with: rectBounds,
                                                          options: .usesLineFragmentOrigin,
                                                          context: nil)
                .size
                .height
        } else {
            fullTextHeight = text?.boundingRect(with: rectBounds,
                                                options: .usesLineFragmentOrigin,
                                                attributes: [NSAttributedString.Key.font: font as Any],
                                                context: nil)
                .size
                .height
        }

        return (fullTextHeight ?? 0) > bounds.size.height
    }
}
