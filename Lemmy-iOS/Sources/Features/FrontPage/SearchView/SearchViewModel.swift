//
//  SearchViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum SearchView {
    
    enum TableRow: Equatable, CaseIterable {
        case comments
        case posts
        case communities
        case users
    }
}
