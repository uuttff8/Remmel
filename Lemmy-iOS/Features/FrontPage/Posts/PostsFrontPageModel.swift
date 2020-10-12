//
//  PostsFrontPageModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostsFrontPageModel: NSObject {
    var goToPostScreen: ((LemmyApiStructs.PostView) -> ())?
    var newDataLoaded: (() -> Void)?
    var dataLoaded: (() -> Void)?
    var isFetchingNewContent = false
    
    var postsDataSource: Array<LemmyApiStructs.PostView> = []
    
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
}


extension PostsFrontPageModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        return handleCellForPosts(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForPosts(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let indexPathRow = indexPath.row
        
        if indexPathRow >= postsDataSource.count - 21 {
            guard !self.isFetchingNewContent else { return }
        }
    }
    
    private func handleDidSelectForPosts(indexPath: IndexPath) {
        self.goToPostScreen?(postsDataSource[indexPath.row])
    }
    
    
    private func handleCellForPosts(indexPath: IndexPath) -> UITableViewCell {
        let postCell = PostContentTableCell()
        postCell.postContentView.delegate = self
        postCell.bind(with: postsDataSource[indexPath.row])
        return postCell
    }
}

extension PostsFrontPageModel: PostContentTableCellDelegate {
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


extension PostsFrontPageModel: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
        
        switch currentContentType {
        case .comments: break
        case .posts: self.loadPosts()
        }
    }
    
    func feedTypeChanged(to feed: LemmyFeedType) {
        self.currentFeedType = feed
        
        switch currentContentType {
        case .comments: break
        case .posts: self.loadPosts()
        }
    }
}