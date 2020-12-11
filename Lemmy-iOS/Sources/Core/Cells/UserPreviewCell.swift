//
//  UserPreviewCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 05.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class UserPreviewCell: UITableViewCell {
    
    struct ViewData {
        let name: String
        let numberOfComments: Int
        let thumbailUrl: String?
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(with viewData: ViewData) {
        self.textLabel?.text = viewData.name
        self.detailTextLabel?.text = String(viewData.numberOfComments) + " Comments"
        
        imageView?.loadImage(urlString: viewData.thumbailUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.detailTextLabel?.text = nil
    }
}
