//
//  CommunityScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CommunityScreenModel: NSObject {
    enum Section: Int, CaseIterable, Hashable {
        case header
        case posts
    }
    
    enum TableRows: Int, Hashable {
        case posts
    }
    
    let communityId: Int
    
    init(communityId: Int) {
        self.communityId = communityId
        super.init()
    }
    
    var cancellable = Set<AnyCancellable>()
    var newDataLoaded: (([LemmyModel.PostView]) -> Void)?
    var dataLoaded: (([LemmyModel.PostView]) -> Void)?
    var goToPostScreen: ((LemmyModel.PostView) -> Void)?
    
    let communitySubject: CurrentValueSubject<LemmyModel.CommunityView?, Never> = CurrentValueSubject(nil)
    let postsSubject: CurrentValueSubject<[LemmyModel.PostView], Never> = CurrentValueSubject([])
    
    let contentTypeSubject: CurrentValueSubject<LemmySortType, Never> = CurrentValueSubject(.active)
    
    private var isFetchingNewContent = false
    private var currentPage = 1
    
    let communityHeaderCell = CommunityHeaderCell()
    
    func loadCommunity(id: Int) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
        
        let parameters = LemmyModel.Community.GetCommunityRequest(id: id, name: nil, auth: jwtToken)
        
        ApiManager.requests.getCommunity(parameters: parameters) { [self] (res) in
            switch res {
            case let .success(response):
                communitySubject.send(response.community)
            case let .failure(error):
                print(error.description)
            }
        }
    }
    
    func asyncLoadPosts(id: Int) {
        let parameters = LemmyModel.Post.GetPostsRequest(type: .community,
                                                         sort: contentTypeSubject.value,
                                                         page: 1,
                                                         limit: 50,
                                                         communityId: id,
                                                         communityName: nil,
                                                         auth: LoginData.shared.jwtToken)
        
        
        ApiManager.shared.requestsManager.asyncGetPosts(parameters: parameters)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (posts) in
                self.postsSubject.send(posts.posts)
                self.dataLoaded?(posts.posts)
            }.store(in: &cancellable)
    }
    
    func loadPosts(id: Int) {
        let parameters = LemmyModel.Post.GetPostsRequest(type: .community,
                                                         sort: contentTypeSubject.value,
                                                         page: 1,
                                                         limit: 50,
                                                         communityId: id,
                                                         communityName: nil,
                                                         auth: LoginData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { (dec: Result<LemmyModel.Post.GetPostsResponse, LemmyGenericError>) in
                switch dec {
                case .success(let posts):
                    self.postsSubject.send(posts.posts)
                    self.dataLoaded?(posts.posts)
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    func loadMorePosts(fromId: Int,completion: @escaping (() -> Void)) {
        let parameters = LemmyModel.Post.GetPostsRequest(type: .community,
                                                         sort: contentTypeSubject.value,
                                                         page: currentPage,
                                                         limit: 50,
                                                         communityId: fromId,
                                                         communityName: nil,
                                                         auth: LoginData.shared.jwtToken)
        
        ApiManager.shared.requestsManager.getPosts(
            parameters: parameters,
            completion: { [self] (dec: Result<LemmyModel.Post.GetPostsResponse, LemmyGenericError>) in
                switch dec {
                case let .success(posts):
                    guard !posts.posts.isEmpty else { return }
                    postsSubject.value.insert(contentsOf: posts.posts, at: postsSubject.value.count)
                    self.newDataLoaded?(posts.posts)
                    completion()
                    
                case .failure(let error):
                    print(error)
                }
            })
    }
    
}

extension CommunityScreenModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleDidSelectForPosts(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !postsSubject.value.isEmpty else { return }
        
        guard case .posts = Section.allCases[indexPath.section] else { return }
        
        let indexPathRow = indexPath.row
        let bottomItems = self.postsSubject.value.count - 5
        
        if indexPathRow >= bottomItems {
            guard !self.isFetchingNewContent else { return }
            
            self.isFetchingNewContent = true
            self.currentPage += 1
            self.loadMorePosts(fromId: communityId) {
                self.isFetchingNewContent = false
            }
        }
    }
    
    private func handleDidSelectForPosts(indexPath: IndexPath) {
        guard case .posts = Section.allCases[indexPath.section] else { return }
        
        self.goToPostScreen?(postsSubject.value[indexPath.row])
    }
}

extension CommunityScreenModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section.allCases[section]
        
        switch section {
        case .header: return 1
        case .posts: return postsSubject.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = Section.allCases[indexPath.section]
        
        switch section {
        case .header:
            guard let community = communitySubject.value else { return LoadingTableViewCell() }
            communityHeaderCell.bindData(community: community)
            return communityHeaderCell
        case .posts:
            guard !postsSubject.value.isEmpty else { return LoadingTableViewCell() }
            
            let cell = tableView.cell(forClass: PostContentTableCell.self)
            cell.postContentView.delegate = self
            cell.bind(with: self.postsSubject.value[indexPath.row], config: .insideComminity)
            
            return cell
        }
        
    }
}

extension CommunityScreenModel: PostContentTableCellDelegate {
    func usernameTapped(in post: LemmyModel.PostView) {
        print(post.creatorName)
    }
    
    // TODO(uuttff8): Implement coordinator to post
    func communityTapped(in post: LemmyModel.PostView) {
        //        goToCommunityScreen?(post)
    }
    
    func upvote(post: LemmyModel.PostView) {
        print("upvote")
    }
    
    func downvote(post: LemmyModel.PostView) {
        print("downvote")
    }
}
