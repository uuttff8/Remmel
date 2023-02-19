//
//  SelectItemViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation

struct SelectItemViewModel {
    let sections: [Section]
    var selectedCell: Section.Cell?

    struct Section {
        let cells: [Cell]

        let headerTitle: String?
        let footerTitle: String?

        struct Cell: UniqueIdentifiable {
            let uniqueIdentifier: UniqueIdentifierType
            let title: String
        }
    }
}
