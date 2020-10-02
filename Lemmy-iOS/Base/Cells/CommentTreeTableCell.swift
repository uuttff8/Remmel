//
//  CommentTreeTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommentTreeTableCell: UITableViewCell {
    
    let commentContentView = CommentContentView()
    
    init() {
        super.init(style: .default, reuseIdentifier: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with comment: CommentNode) {
        self.contentView.addSubview(commentContentView)
        
        self.commentContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        commentContentView.bind(with: comment.comment)
        
        setupUI()
    }
    
    func setupUI() {
        let selBackView = UIView()
        selBackView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        self.selectedBackgroundView = selBackView
    }
}
