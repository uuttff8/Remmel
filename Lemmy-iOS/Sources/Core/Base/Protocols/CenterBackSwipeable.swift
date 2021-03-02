//
//  CenterBackSwipeable.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CenterBackSwipeable {
    func enableCenterBackSwipe()
}

extension CenterBackSwipeable where Self: UIViewController {
    func enableCenterBackSwipe() {
        let popGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")
            self.view.addGestureRecognizer(gestureRecognizer)
        }
    }
}
