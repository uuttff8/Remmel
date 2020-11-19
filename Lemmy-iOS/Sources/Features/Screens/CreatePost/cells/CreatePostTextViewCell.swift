//
//  CreatePostTextViewCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostContentCell: UITableViewCell {
    
    lazy var innerTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.textColor = UIColor.lightGray
        tv.placeholder = "Title"
        return tv
    }()

}
