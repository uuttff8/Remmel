//
//  IncreasedTapAreaButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 31.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class IncreasedTapAreaButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
