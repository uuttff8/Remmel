//
//  CommunityPreviewTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class CommunityPreviewTableCell: UITableViewCell {
    private let iconSize = CGSize(width: 20, height: 20)
    
    struct ViewData {
        let imageUrl: String?
        let name: String
        let category: String
        let subscribers: Int
    }
        
    private let subscribersLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    
    func bind(with data: CommunityPreviewTableCell.ViewData) {
        if let imageUrl = data.imageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: imageUrl)!), into: self.imageView!)
        }
        
        self.textLabel?.text = data.name
        self.detailTextLabel?.text = data.category
    }
}
