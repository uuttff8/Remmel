//
//  FrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FrontPageModel: NSObject {
    var dataLoaded: (() -> Void)?
    var newDataLoaded: (() -> Void)?
    var goToPostScreen: ((LemmyApiStructs.PostView) -> ())?
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
    
    var postsDataSource: Array<LemmyApiStructs.PostView>?
    var commentsDataSource: Array<LemmyApiStructs.CommentView>?
    
    func loadPosts() {
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type_: self.currentFeedType,
                                                              sort: LemmySortType.active,
                                                              page: 1,
                                                              limit: 20,
                                                              communityId: nil,
                                                              communityName: nil,
                                                              auth: nil)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyApiStructs.Post.GetPostsResponse, Error>) in
                switch dec {
                case .success(let posts):
                    self.postsDataSource = posts.posts
                    DispatchQueue.main.async {
                        self.dataLoaded?()
                    }
                    
                case .failure(let error):
                    print(error)
                }
        })
    }
    
    func loadMorePosts() {
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type_: self.currentFeedType,
                                                              sort: LemmySortType.active,
                                                              page: 2,
                                                              limit: 20,
                                                              communityId: nil,
                                                              communityName: nil,
                                                              auth: nil)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyApiStructs.Post.GetPostsResponse, Error>) in
                switch dec {
                case .success(let posts):
                    self.postsDataSource = posts.posts
                    DispatchQueue.main.async {
                        self.newDataLoaded?()
                    }
                    
                case .failure(let error):
                    print(error)
                }
        })

    }
    
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


extension FrontPageModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FrontPageCells.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = FrontPageCells.allCases[section]
        switch section {
        case .header:
            return 1
        case .content:
            switch currentContentType {
            case .posts:
                guard let posts = postsDataSource else {
                    return 0
                }
                return posts.count
            case .comments:
                guard let comments = commentsDataSource else {
                    return 0
                }
                return comments.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .header:
            let cell = FrontPageHeaderCell(contentSelected: currentContentType, feedType: currentFeedType)
            cell.customView.delegate = self
            return cell
        case .content:
            
            switch currentContentType {
            case .posts:
                return handleCellForPosts(indexPath: indexPath)
            case .comments:
                return handleCellForComments(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .content:
            switch currentContentType {
            case .comments:
                handleDidSelectForComments(indexPath: indexPath)
            case .posts:
                handleDidSelectForPosts(indexPath: indexPath)
            }

        case .header:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let section = FrontPageCells.allCases[indexPath.section]
        let indexPathRow = indexPath.row
        
        switch section {
        case .content:
            switch currentContentType {
            case .comments:
                guard let comments = commentsDataSource else { return }
                
                if indexPathRow >= comments.count - 21 {
                    guard !self.isFetchingNewContent else { return }
                    
                    
                }
            case .posts:
                guard let posts = postsDataSource else { return }
                
                if indexPathRow >= posts.count - 21 {
                    guard !self.isFetchingNewContent else { return }
                    
                    
                    
                }
            }

        case .header:
            break
        }

        
    }
    
    private func handleDidSelectForPosts(indexPath: IndexPath) {
        guard let posts = postsDataSource else {
            return
        }
        self.goToPostScreen?(posts[indexPath.row])
    }
    
    // TODO(uuttff8): go to comments
    private func handleDidSelectForComments(indexPath: IndexPath) { }
    
    private func handleCellForPosts(indexPath: IndexPath) -> UITableViewCell {
        guard let posts = postsDataSource else {
            return UITableViewCell()
        }
        let postCell = PostContentTableCell()
        postCell.postContentView.delegate = self
        postCell.bind(with: posts[indexPath.row])
        return postCell
    }
    
    private func handleCellForComments(indexPath: IndexPath) -> UITableViewCell {
        guard let comments = commentsDataSource else {
            return UITableViewCell()
        }
        let commentCell = CommentContentTableCell()
        commentCell.commentContentView.delegate = self
        commentCell.bind(with: comments[indexPath.row])
        return commentCell
    }
}

extension FrontPageModel: PostContentTableCellDelegate {
    func usernameTapped(in post: LemmyApiStructs.PostView) {
        print(post.creatorName)
    }
    
    func communityTapped(in post: LemmyApiStructs.PostView) {
        print(post.communityName)
    }
    
    func upvote(post: LemmyApiStructs.PostView) {
        print("upvote")
    }
    
    func downvote(post: LemmyApiStructs.PostView) {
        print("downvote")
    }
}

extension FrontPageModel: CommentContentTableCellDelegate {
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

extension FrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
        
        switch currentContentType {
        case .comments: self.loadComments()
        case .posts: self.loadPosts()
        }
    }
    
    func feedTypeChanged(to feed: LemmyFeedType) {
        self.currentFeedType = feed
        
        switch currentContentType {
        case .comments: self.loadComments()
        case .posts: self.loadPosts()
        }
    }
}

private enum FrontPageCells: CaseIterable {
    case header
    case content
}
