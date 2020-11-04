//
//  LemmyView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyView: UIView {
    var presentOnVc: ((UIViewController) -> Void)?
    var dismissOnVc: (() -> Void)?
}
