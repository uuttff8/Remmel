//
//  LemmyCommentsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class FoldableLemmyCommentsViewController: CommentsViewController, SwiftyCommentTableViewDataSource {
    var allComments: [LemmyComment] = []
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(CommentContentTableCell.self)
    }
    
    func showComments(with comments: [LemmyComment]) {
        self.allComments = comments
        
        self.delegate = self
        self.fullyExpanded = true
        
        self.dataSource = self
        self.currentlyDisplayed = comments
        self.tableView.reloadData()
    }
    
    func setupHeaderView(_ headerView: UIView) {
        self.tableView.tableHeaderView = headerView
        self.tableView.layoutTableHeaderView()
    }
    
    func commentsView(
        _ tableView: UITableView,
        commentCellForModel commentModel: AbstractComment,
        atIndexPath indexPath: IndexPath
    ) -> CommentCell {
        
        let commentCell: CommentContentTableCell = tableView.cell(forRowAt: indexPath)
        let comment = currentlyDisplayed[indexPath.row] as! LemmyComment
        
        commentCell.bind(with: comment.commentContent!, level: comment.level, appearance: .init(config: .inPost))
        
        return commentCell
    }
}

extension FoldableLemmyCommentsViewController: CommentsViewDelegate {
    func commentCellExpanded(atIndex index: Int) {
        updateCellFoldState(false, atIndex: index)
    }
    
    func commentCellFolded(atIndex index: Int) {
        updateCellFoldState(true, atIndex: index)
    }

    private func updateCellFoldState(_ folded: Bool, atIndex index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! CommentContentTableCell
        cell.animateIsFolded(fold: folded)
        (self.currentlyDisplayed[index] as! LemmyComment).isFolded = folded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
