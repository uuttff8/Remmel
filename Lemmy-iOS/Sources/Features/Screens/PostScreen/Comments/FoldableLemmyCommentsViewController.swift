//
//  LemmyCommentsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol CommentsViewControllerDelegate: CommentContentTableCellDelegate { }

final class FoldableLemmyCommentsViewController: CommentsViewController, SwiftyCommentTableViewDataSource {
    weak var commentDelegate: CommentsViewControllerDelegate?
    
    var commentDataSource: [LemmyComment] {
        get { currentlyDisplayed as! [LemmyComment] }
        set { (currentlyDisplayed) = newValue }
    }
    
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
        self.delegate = self
        self.fullyExpanded = true
        
        self.dataSource = self
        self.currentlyDisplayed = comments
        self.tableView.reloadData()
    }
    
    func saveNewComment(comment: LemmyModel.CommentView) {
        if let index = commentDataSource.firstIndex(where: { comment in
            comment.commentContent?.id == comment.id
        }) {
            commentDataSource[index].commentContent = comment
        }
    }
    
    func scrollTo(_ comment: LemmyModel.CommentView) {
        guard let index = commentDataSource.firstIndex(where: { $0.commentContent?.id == comment.id }) else {
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! CommentContentTableCell
        cell.focusOnContent()
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
        let comment = getCommentData(from: indexPath)
        
        commentCell.bind(with: comment.commentContent!, level: comment.level, appearance: .init(config: .inPost))
        commentCell.commentContentView.delegate = commentDelegate
        
        return commentCell
    }
    
    private func getCommentData(from indexPath: IndexPath) -> LemmyComment {
        currentlyDisplayed[indexPath.row] as! LemmyComment
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
