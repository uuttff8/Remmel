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
    
    // at init always posts
    var currentContentType: LemmyContentType = LemmyContentType.posts {
        didSet {
            print(currentContentType)
        }
    }
    
    var postsDataSource: Array<LemmyApiStructs.PostView>?
    var commentsDataSource: Array<LemmyApiStructs.CommentView>?
    
    func loadPosts() {
        let parameters = LemmyApiStructs.Post.GetPostsRequest(type_: "All",
                                                              sort: "Active",
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
    
    func loadComments() {
        let parameters = LemmyApiStructs.Comment.GetCommentsRequest(type_: LemmyFeedType.all,
                                                                    sort: "Active",
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
                return 4
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .header:
            let cell = FrontPageHeaderCell(contentSelectedIndex: currentContentType)
            cell.delegate = self
            return cell
        case .content:
            
            switch currentContentType {
            case .posts:
                return handleCellForPosts(indexPath: indexPath)
            case .comments:
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.red
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = FrontPageCells.allCases[indexPath.section]
        
        switch section {
        case .content:
            tableView.deselectRow(at: indexPath, animated: true)
        case .header:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func handleCellForPosts(indexPath: IndexPath) -> UITableViewCell {
        guard let posts = postsDataSource else {
            return UITableViewCell()
        }
        let postCell = PostContentTableCell()
        postCell.delegate = self
        postCell.bind(with: posts[indexPath.row])
        return postCell
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

extension FrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        currentContentType = content
        
        switch currentContentType {
        case .comments: self.loadComments()
        case .posts: self.loadPosts()
        }
    }
    
    func feedTypeChanged(to feed: LemmyFeedType) {
        
    }
}

private enum FrontPageCells: CaseIterable {
    case header
    case content
}
