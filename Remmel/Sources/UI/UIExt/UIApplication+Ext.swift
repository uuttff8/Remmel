//
//  UIApplication+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIApplication {
    var lemmyStatusBarFrame: CGRect {
        if #available(iOS 13, *) {
            let windowScene = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene
            // swiftlint:disable:next force_unwrapping
            return windowScene!.statusBarManager!.statusBarFrame
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }
}
