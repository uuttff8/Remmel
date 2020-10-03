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
    let commentNode: CommentNode
    
    init(commentNode: CommentNode) {
        self.commentNode = commentNode
        super.init(style: .default, reuseIdentifier: .none)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.contentView.addSubview(commentContentView)
        
        commentContentView.bind(with: commentNode.comment)
        
        setupUI()
        
        if !commentNode.replies.isEmpty {
            drawReplies()
        } else {
            layoutCommentWithoutReplies()
        }
    }
    
    func setupUI() {
        let selBackView = UIView()
        selBackView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        self.selectedBackgroundView = selBackView
    }
    
    func layoutCommentWithoutReplies() {
        self.commentContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func drawReplies() {
        self.commentContentView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        
        commentNode.replies.forEach { (node) in
            let viewCell = CommentTreeTableCell(commentNode: node)
            self.contentView.addSubview(viewCell)
            viewCell.snp.makeConstraints { (make) in
                make.top.equalTo(self.commentContentView.snp.bottom)
                make.leading.equalToSuperview().inset(10)
                make.bottom.trailing.equalToSuperview()
            }
        }
    }
}
