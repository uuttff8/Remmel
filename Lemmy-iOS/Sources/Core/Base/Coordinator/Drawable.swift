//
//  Drawable.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 30.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}

