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
    func doPostLike(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) // refactor
    func doCommentLike(voteButton: VoteButton, for newVote: LemmyVoteType, comment: LemmyModel.CommentView)
}

class SearchResultsViewModel: SearchResultsViewModelProtocol {
    weak var viewController: SearchResultsViewController?
    
    private var cancellable = Set<AnyCancellable>()
    
    private let searchQuery: String
    private let searchType: LemmySearchSortType
    
    private let userAccountService: UserAccountSerivceProtocol
    private let contentScoreService: ContentScoreServiceProtocol
    
    init(
        searchQuery: String,
        searchType: LemmySearchSortType,
        userAccountService: UserAccountSerivceProtocol,
        contentScoreService: ContentScoreServiceProtocol
    ) {
        self.searchQuery = searchQuery
        self.searchType = searchType
        self.userAccountService = userAccountService
        self.contentScoreService = contentScoreService
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
            } receiveValue: { [weak self] (response) in
                guard let self = self else { return }
                self.makeViewModelAndPresent(type: self.searchType,
                                             response: response)
                
            }.store(in: &cancellable)
    }
    
    func doPostLike(voteButton: VoteButton, for newVote: LemmyVoteType, post: LemmyModel.PostView) {
        self.contentScoreService.votePost(
            voteButton: voteButton,
            for: newVote,
            post: post
        ) {
            self.viewController?.operateSaveNewPost(viewModel: .init(post: $0))
        }
    }
    
    func doCommentLike(voteButton: VoteButton, for newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        self.contentScoreService.voteComment(
            voteButton: voteButton,
            for: newVote,
            comment: comment
        ) {
            self.viewController?.operateSaveNewComment(viewModel: .init(comment: $0))
        }
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
    
    enum SavePost {
        struct Request { }
        
        struct ViewModel {
            let post: LemmyModel.PostView
        }
    }
    
    enum SaveComment {
        struct Request { }
        
        struct ViewModel {
            let comment: LemmyModel.CommentView
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
