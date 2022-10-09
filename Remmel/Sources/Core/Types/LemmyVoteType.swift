//
//  LemmyVoteType.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

enum LemmyVoteType: Int, Codable {
    case none = 0
    case up = 1
    case down = -1
}
