//
//  SearchViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol SearchResultsViewModelProtocol: AnyObject {
    func doLoadPosts(request: SearchResults.LoadPosts.Request)
    func doLoadUsers(request: SearchResults.LoadUsers.Request)
    func doLoadCommunities(request: SearchResults.LoadCommunities.Request)
    func doLoadComments(request: SearchResults.LoadComments.Request)
}

class SearchResultsSearchViewModel: SearchResultsViewModelProtocol {
    weak var viewController: SearchResultsViewController?
    
    private var cancellable = Set<AnyCancellable>()
    
    private let searchQuery: String
    
    init(
        searchQuery: String
    ) {
        self.searchQuery = searchQuery
    }
    
    func doLoadPosts(request: SearchResults.LoadPosts.Request) {
        let params = LemmyModel.Search.SearchRequest(query: self.searchQuery,
                                                     type: .posts,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     sort: .active,
                                                     page: 0,
                                                     limit: 50,
                                                     auth: "")
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (response) in
                
                self.viewController?.displayPosts(
                    viewModel: .init(state: .result(response.posts))
                )
                
            }.store(in: &cancellable)

    }
    
    func doLoadUsers(request: SearchResults.LoadUsers.Request) {
        let params = LemmyModel.Search.SearchRequest(query: self.searchQuery,
                                                     type: .users,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     sort: .active,
                                                     page: 0,
                                                     limit: 50,
                                                     auth: "")
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (response) in
                
                self.viewController?.displayUsers(
                    viewModel: .init(state: .result(response.users))
                )
                
            }.store(in: &cancellable)

    }
    
    func doLoadCommunities(request: SearchResults.LoadCommunities.Request) {
        let params = LemmyModel.Search.SearchRequest(query: self.searchQuery,
                                                     type: .communities,
                                                     communityId: nil,
                                                     communityName: self.searchQuery,
                                                     sort: .active,
                                                     page: 0,
                                                     limit: 50,
                                                     auth: "")
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (response) in
                
                self.viewController?.displayCommunities(
                    viewModel: .init(state: .result(response.communities))
                )
                
            }.store(in: &cancellable)
    }
    
    func doLoadComments(request: SearchResults.LoadComments.Request) {
        let params = LemmyModel.Search.SearchRequest(query: self.searchQuery,
                                                     type: .comments,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     sort: .active,
                                                     page: 0,
                                                     limit: 50,
                                                     auth: "")
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (response) in
                
                self.viewController?.displayComments(
                    viewModel: .init(state: .result(response.comments))
                )
                
            }.store(in: &cancellable)
    }
}

enum SearchResults {
    
    enum LoadPosts {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState<[LemmyModel.PostView]>
        }
    }
    
    enum LoadUsers {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState<[LemmyModel.UserView]>
        }
    }
    
    enum LoadCommunities {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState<[LemmyModel.CommunityView]>
        }
    }
    
    enum LoadComments {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState<[LemmyModel.CommentView]>
        }
    }
    
    enum ViewControllerState<T: Codable> {
        case loading
        case result(T)
    }
}
