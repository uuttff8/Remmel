//
//  Collection+SafeSubscript.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}
