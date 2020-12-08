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
    func doLoadContent(request: SearchResults.LoadContent.Request)
}

class SearchResultsViewModel: SearchResultsViewModelProtocol {
    weak var viewController: SearchResultsViewController?
    
    private var cancellable = Set<AnyCancellable>()
    
    private let searchQuery: String
    private let searchType: LemmySearchSortType
    
    private let userAccountService: UserAccountSerivceProtocol
    
    init(
        searchQuery: String,
        searchType: LemmySearchSortType,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.searchQuery = searchQuery
        self.searchType = searchType
        self.userAccountService = userAccountService
    }
    
    func doLoadContent(request: SearchResults.LoadContent.Request) {
        let params = LemmyModel.Search.SearchRequest(query: self.searchQuery,
                                                     type: self.searchType,
                                                     sort: .topAll,
                                                     page: 1,
                                                     limit: 20,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     auth: userAccountService.jwtToken)

        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                print(completion)
            } receiveValue: { (response) in
                
                self.makeViewModelAndPresent(type: self.searchType,
                                             response: response)
                
            }.store(in: &cancellable)
    }
    
    private func makeViewModelAndPresent(
        type: LemmySearchSortType,
        response: LemmyModel.Search.SearchResponse
    ) {
        
        let result: SearchResults.Results
        
        switch type {
        case .comments:
            result = .comments(response.comments)
        case .posts:
            result = .posts(response.posts)
        case .communities:
            result = .communities(response.communities)
        case .users:
            result = .users(response.users)
        default:
            fatalError("This: \(type) should never be called on search.")
        }
        
        self.viewController?.displayContent(
            viewModel: .init(state: .result(result))
        )
    }
}

enum SearchResults {
    
    enum LoadContent {
        struct Request { }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
        
    enum Results {
        case comments([LemmyModel.CommentView])
        case posts([LemmyModel.PostView])
        case communities([LemmyModel.CommunityView])
        case users([LemmyModel.UserView])
    }
    
    enum ViewControllerState {
        case loading
        case result(Results)
    }
}


// yes
//{
//  "op": "Search",
//  "data": {
//    "q": "There are subtantail privacy ",
//    "type_": "Posts",
//    "sort": "TopAll",
//    "page": 1
//    "limit": 50,
//    "auth": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTQxNjUsImlzcyI6ImxlbW15Lm1sIn0.NNTF0FbKEyG-y1fPqvccQ8ut-rBCyYEncU5LbHv-CTE",
//  }
//}
//
//// no
//{
//  "op": "Search",
//  "data": {
//    "limit": 20,
//    "type_": "Posts",
//    "auth": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTQxNjUsImlzcyI6ImxlbW15Lm1sIn0.NNTF0FbKEyG-y1fPqvccQ8ut-rBCyYEncU5LbHv-CTE",
//    "q": "There are subtantail privacy",
//    "sort": "TopAll",
//    "page": 1
//  }
//}
