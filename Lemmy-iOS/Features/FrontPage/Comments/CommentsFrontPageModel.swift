//
//  CommentsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommentsFrontPageModel: NSObject {
    var dataLoaded: (() -> Void)?
    var newDataLoaded: (() -> Void)?
    var goToCommentScreen: ((LemmyApiStructs.CommentView) -> ())?
    var isFetchingNewContent = false
    
    // at init always posts
    var currentContentType: LemmyContentType = LemmyContentType.posts {
        didSet {
            print(currentContentType)
        }
    }
    
    // at init always all
    var currentFeedType: LemmyFeedType = LemmyFeedType.all {
        didSet {
            print(currentFeedType)
        }
    }
    
    var commentsDataSource: Array<LemmyApiStructs.CommentView> = []
    
    
    func loadComments() {
        let parameters = LemmyApiStructs.Comment.GetCommentsRequest(type_: self.currentFeedType,
                                                                    sort: LemmySortType.hot,
                                                                    page: 1,
                                                                    limit: 20,
                                                                    auth: nil)
        
        ApiManager.shared.requestsManager.getComments(parameters: parameters)
        { (res: Result<LemmyApiStructs.Comment.GetCommentsResponse, Error>) in
            switch res {
            case .success(let response):
                self.commentsDataSource = response.comments
                DispatchQueue.main.async {
                    self.dataLoaded?()
                    print(self.currentContentType)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CommentsFrontPageModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return handleCellForComments(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForComments(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // TODO(uuttff8): go to comments
    private func handleDidSelectForComments(indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        
        if indexPathRow >= commentsDataSource.count - 21 {
            guard !self.isFetchingNewContent else { return }
        }
    }
    
    private func handleCellForComments(indexPath: IndexPath) -> UITableViewCell {
        let commentCell = CommentContentTableCell()
        commentCell.commentContentView.delegate = self
        commentCell.bind(with: commentsDataSource[indexPath.row])
        return commentCell
    }
}

extension CommentsFrontPageModel: CommentContentTableCellDelegate {
    func postNameTapped(in comment: LemmyApiStructs.CommentView) {
        print("post name tapped in \(comment.id)")
    }
    
    func usernameTapped(in comment: LemmyApiStructs.CommentView) {
        print(comment.creatorName)
    }
    
    func communityTapped(in comment: LemmyApiStructs.CommentView) {
        print(comment.communityName)
    }
    
    func upvote(comment: LemmyApiStructs.CommentView) {
        print("\(comment) upvoted")
    }
    
    func downvote(comment: LemmyApiStructs.CommentView) {
        print("\(comment) downvoted")
    }
    
    func showContext(in comment: LemmyApiStructs.CommentView) {
        print("show context in \(comment.id)")
    }
    
    func reply(to comment: LemmyApiStructs.CommentView) {
        print("reply to \(comment.id)")
    }
    
    func showMoreAction(in comment: LemmyApiStructs.CommentView) {
        print("show more in \(comment.id)")
    }
}

extension CommentsFrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
        self.loadComments()
    }
    
    func feedTypeChanged(to feed: LemmyFeedType) {
        self.currentFeedType = feed
        self.loadComments()
    }
}

