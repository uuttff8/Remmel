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
                                              sort: .topAll,
                                              page: 1,
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
        ) {
            self.viewController?.operateSaveNewPost(viewModel: .init(post: $0))
        }
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
        ) {
            self.viewController?.operateSaveNewComment(viewModel: .init(comment: $0))
        }
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
        case users([LMModels.Views.UserViewSafe])
    }
    
    enum ViewControllerState {
        case loading
        case result(Results)
    }
}
