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
    func doLoadMoreContent(request: SearchResults.LoadMoreContent.Request)
    func doPostLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LMModels.Views.PostView
    ) // refactor
    func doCommentLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LMModels.Views.CommentView
    )
}

class SearchResultsViewModel: SearchResultsViewModelProtocol {
    weak var viewController: SearchResultsViewController?
    
    private var cancellable = Set<AnyCancellable>()
    
    private let searchQuery: String
    private let searchType: LMModels.Others.SearchType
    
    private var paginationState = 1
    private var searchData: SearchResults.Results = .posts([])
    
    private let userAccountService: UserAccountSerivceProtocol
    private let contentScoreService: ContentScoreServiceProtocol
    
    init(
        searchQuery: String,
        searchType: LMModels.Others.SearchType,
        userAccountService: UserAccountSerivceProtocol,
        contentScoreService: ContentScoreServiceProtocol
    ) {
        self.searchQuery = searchQuery
        self.searchType = searchType
        self.userAccountService = userAccountService
        self.contentScoreService = contentScoreService
    }
    
    func doLoadContent(request: SearchResults.LoadContent.Request) {
        let params = LMModels.Api.Site.Search(query: self.searchQuery,
                                              type: self.searchType,
                                              communityId: nil,
                                              communityName: nil,
                                              creatorId: nil,
                                              sort: .topAll,
                                              listingType: nil,
                                              page: request.page,
                                              limit: 20,
                                              auth: userAccountService.jwtToken)
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                self.makeViewModelAndPresent(type: self.searchType,
                                             response: response)
                
            }.store(in: &cancellable)
    }
    
    func doLoadMoreContent(request: SearchResults.LoadMoreContent.Request) {
        self.paginationState += 1
        
        let params = LMModels.Api.Site.Search(query: self.searchQuery,
                                              type: self.searchType,
                                              communityId: nil,
                                              communityName: nil,
                                              creatorId: nil,
                                              sort: .topAll,
                                              listingType: nil,
                                              page: self.paginationState,
                                              limit: 20,
                                              auth: userAccountService.jwtToken)
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                self.makePaginationViewModelAndPresent(type: self.searchType,
                                                       response: response)
                
            }.store(in: &cancellable)
    }
    
    func doPostLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        post: LMModels.Views.PostView
    ) {
        self.contentScoreService.votePost(
            scoreView: scoreView,
            voteButton: voteButton,
            for: newVote,
            post: post
        )
    }
    
    func doCommentLike(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        for newVote: LemmyVoteType,
        comment: LMModels.Views.CommentView
    ) {
        self.contentScoreService.voteComment(
            scoreView: scoreView,
            voteButton: voteButton,
            for: newVote,
            comment: comment
        )
    }
    
    private func makeViewModelAndPresent(
        type: LMModels.Others.SearchType,
        response: LMModels.Api.Site.SearchResponse
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
        
        self.searchData = result
        self.viewController?.displayContent(
            viewModel: .init(state: .result(result))
        )
    }
    
    private func makePaginationViewModelAndPresent(
        type: LMModels.Others.SearchType,
        response: LMModels.Api.Site.SearchResponse
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
        
        self.viewController?.displayMoreContent(
            viewModel: .init(state: .result(result))
        )
    }
}

enum SearchResults {
    
    enum LoadContent {
        struct Request {
            let page: Int
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum LoadMoreContent {
        struct Request { }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum SavePost {
        struct Request { }
        
        struct ViewModel {
            let post: LMModels.Views.PostView
        }
    }
    
    enum SaveComment {
        struct Request { }
        
        struct ViewModel {
            let comment: LMModels.Views.CommentView
        }
    }
    
    enum Results {
        case comments([LMModels.Views.CommentView])
        case posts([LMModels.Views.PostView])
        case communities([LMModels.Views.CommunityView])
        case users([LMModels.Views.PersonViewSafe])
    }
    
    enum ViewControllerState {
        case loading
        case result(Results)
    }
}
