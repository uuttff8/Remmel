//
//  LemmyUITableView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyTableView: UITableView {
    init(style: UITableView.Style, separator: Bool = false) {
        super.init(frame: .zero, style: style)
        self.tableFooterView = UIView()
        self.rowHeight = UITableView.automaticDimension
//        self.estimatedRowHeight = 40
        self.keyboardDismissMode = .onDrag
        
        if separator {
            self.separatorStyle = .singleLine
        } else {
            self.separatorStyle = .none
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
