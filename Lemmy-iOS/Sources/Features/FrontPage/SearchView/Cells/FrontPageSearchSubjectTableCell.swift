//
//  FrontPageSearchSubjectTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FrontPageSearchSubjectTableCell: UITableViewCell {
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        textLabel?.font = .systemFont(ofSize: 14)
    }
    
    func configure(with query: String, type: SearchView.TableRow) {
        
        switch type {
        case .comments:
            textLabel?.text = "Search comments with \(query)"
        case .users:
            textLabel?.text = "Search users with @\(query)"
        case .communities:
            textLabel?.text = "Search communities with !\(query)"
        case .posts:
            textLabel?.text = "Search posts with \(query)"
        }
        
    }
    
    override func prepareForReuse() {
        textLabel?.text = nil
    }
}
