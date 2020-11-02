//
//  CommentsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommentsFrontPageModel: NSObject {
    var dataLoaded: (([LemmyApiStructs.CommentView]) -> Void)?
    var newDataLoaded: (([LemmyApiStructs.CommentView]) -> Void)?
    var goToCommentScreen: ((LemmyApiStructs.CommentView) -> Void)?

    private var isFetchingNewContent = false
    private var currentPage = 1

    var commentsDataSource: [LemmyApiStructs.CommentView] = []

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

    func loadComments() {
        let parameters = LemmyApiStructs.Comment.GetCommentsRequest(type: self.currentFeedType,
                                                                    sort: LemmySortType.hot,
                                                                    page: 1,
                                                                    limit: 20,
                                                                    auth: nil)

        ApiManager.shared.requestsManager.getComments(
            parameters: parameters
        ) { (res: Result<LemmyApiStructs.Comment.GetCommentsResponse, LemmyGenericError>) in
            switch res {
            case .success(let response):
                self.commentsDataSource = response.comments
                self.dataLoaded?(response.comments)
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadMoreComments(completion: @escaping (() -> Void)) {
        let parameters = LemmyApiStructs.Comment.GetCommentsRequest(type: self.currentFeedType,
                                                                    sort: LemmySortType.hot,
                                                                    page: currentPage,
                                                                    limit: 20,
                                                                    auth: nil)

        ApiManager.shared.requestsManager.getComments(
            parameters: parameters
        ) { (res: Result<LemmyApiStructs.Comment.GetCommentsResponse, LemmyGenericError>) in
            switch res {
            case .success(let response):
                self.newDataLoaded?(response.comments)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension CommentsFrontPageModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForComments(indexPath: indexPath)

        tableView.deselectRow(at: indexPath, animated: true)

    }

    // TODO(uuttff8): go to comments
    private func handleDidSelectForComments(indexPath: IndexPath) { }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        let bottomItems = self.commentsDataSource.count - 5

        if indexPathRow >= bottomItems {
            guard !self.isFetchingNewContent else { return }

            self.isFetchingNewContent = true
            self.currentPage += 1
            self.loadMoreComments {
                self.isFetchingNewContent = false
            }
        }
    }
}

extension CommentsFrontPageModel: CommentContentTableCellDelegate {
    
    // TODO(uuttff8): Implement coordinator to post
    func postNameTapped(in comment: LemmyApiStructs.CommentView) {
        print("post name tapped in \(comment.id)")
        
        fatalError("Implement coordinator to post")
    }

    func usernameTapped(in comment: LemmyApiStructs.CommentView) {
        print(comment.creatorName)
    }

    // TODO(uuttff8): Implement coordinator to post
    func communityTapped(in comment: LemmyApiStructs.CommentView) {
        print(comment.communityName)
        
        fatalError("Implement coordinator to post")
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
