//
//  UIBarButton+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(
        title: String? = nil,
        image: UIImage? = nil,
        primaryAction: UIAction? = nil,
        menu: UIMenu? = nil,
        style: UIBarButtonItem.Style? = nil
    ) {
        self.init(title: title, image: image, primaryAction: primaryAction, menu: menu)
        if let style = style {
            self.style = style
        }
    }
}
