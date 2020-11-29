//
//  CommentTreeTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/2/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}

class CommentTreeTableCell: UITableViewCell {

    var frameHeight: CGFloat = 0
    let tableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        return tv
    }()
    let commentContentView = CommentContentView()
    let selBackView = UIView()
    
    var commentNode: CommentNode?
    
    func bind(with commentNode: CommentNode) {
        self.commentNode = commentNode
        self.contentView.addSubview(commentContentView)

//        commentContentView.bind(with: commentNode.comment)

        setupUI()

        if !commentNode.replies.isEmpty {
            drawReplies()
        } else {
            layoutCommentWithoutReplies()
        }
    }

    func setupUI() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
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
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        self.contentView.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(commentContentView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension CommentTreeTableCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let commentNode = commentNode else { return 1 }
        return commentNode.replies.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let commentNode = commentNode else { return UITableViewCell() }
        let commentSectionData = commentNode.replies[indexPath.section]
        let cell = CommentTreeTableCell()
        cell.bind(with: commentSectionData)
        return cell
    }
}
