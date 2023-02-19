//
//  FrontPageSearchSubjectTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

class FrontPageSearchSubjectTableCell: UITableViewCell {
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        textLabel?.font = .systemFont(ofSize: 14)
    }
    
    func configure(with query: String, type: RMModel.Others.SearchType) {
        
        switch type {
        case .comments:
            textLabel?.text = "front-search-comments".localized + " \(query)"
        case .users:
            textLabel?.text = "front-search-users".localized + " @\(query)"
        case .communities:
            textLabel?.text = "front-search-communities".localized + " !\(query)"
        case .posts:
            textLabel?.text = "front-search-posts".localized + " \(query)"
        default:
            break
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
}
