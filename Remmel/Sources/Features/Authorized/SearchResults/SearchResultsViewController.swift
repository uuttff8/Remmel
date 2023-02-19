//
//  SearchResultsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMFoundation
import RMServices
import RMModels

protocol SearchResultsViewControllerProtocol: AnyObject {
    func displayContent(viewModel: SearchResults.LoadContent.ViewModel)
    func displayMoreContent(viewModel: SearchResults.LoadMoreContent.ViewModel)
    func operateSaveNewPost(viewModel: SearchResults.SavePost.ViewModel)
    func operateSaveNewComment(viewModel: SearchResults.SaveComment.ViewModel)
}

class SearchResultsViewController: UIViewController {
    
    weak var coordinator: FrontPageCoordinator?
    
    private let viewModel: SearchResultsViewModelProtocol
    
    private var state: SearchResults.ViewControllerState
    private var canTriggerPagination = true

    private let showMoreHandler: ShowMoreHandlerService
    private let followService: CommunityFollowServiceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var tableManager = SearchResultsTableDataSource().then {
        $0.delegate = self
    }
    private lazy var resultsView = view as? SearchResultsView
    
    init(
        viewModel: SearchResultsViewModelProtocol,
        state: SearchResults.ViewControllerState = .loading,
        showMoreHandler: ShowMoreHandlerService,
        followService: CommunityFollowServiceProtocol
    ) {
        self.viewModel = viewModel
        self.state = state
        self.showMoreHandler = showMoreHandler
        self.followService = followService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = SearchResultsView(tableManager: tableManager)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateState(newState: self.state)
        
        self.viewModel.doLoadContent(request: .init(page: 1))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.coordinator?.free(coordinator)
    }
    
    private func updateState(newState: SearchResults.ViewControllerState) {
        defer {
            state = newState
        }

        if case .loading = newState {
            resultsView?.showActivityIndicatorView()
        }

        if case .loading = state {
            resultsView?.hideActivityIndicatorView()
        }

        if case .result(let data) = newState {
            let objects: [Any] = getObjects(from: data)
            
            if objects.isEmpty {
                resultsView?.displayNoData()
            } else {
                resultsView?.updateTableViewData(delegate: tableManager)
            }
        }
    }
}

extension SearchResultsViewController: SearchResultsViewControllerProtocol {
    func displayContent(viewModel: SearchResults.LoadContent.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }
        
        tableManager.viewModels = data
        updateState(newState: viewModel.state)
    }
    
    func displayMoreContent(viewModel: SearchResults.LoadMoreContent.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }
                
        let objects: [Any] = getObjects(from: data)
        tableManager.appendViewModels(viewModel: data)
        resultsView?.appendNew(data: objects)
        
        if objects.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
    
    func operateSaveNewPost(viewModel: SearchResults.SavePost.ViewModel) {
        tableManager.saveNewPost(post: viewModel.post)
    }
    
    func operateSaveNewComment(viewModel: SearchResults.SaveComment.ViewModel) {
        tableManager.saveNewComment(comment: viewModel.comment)
    }
    
    private func getObjects(from data: SearchResults.Results) -> [Any] {
        switch data {
        case let .comments(data):
            return data
        case let .communities(data):
            return data
        case let .posts(data):
            return data
        case let .users(data):
            return data
        }
    }
}

extension SearchResultsViewController: SearchResultsTableDataSourceDelegate {
    func postCellDidSelected(postId: RMModel.Views.PostView.ID) {
        guard case .posts(let posts) = tableManager.viewModels else {
            return
        }
        let post = posts.getElement(by: postId).require()
        coordinator?.goToPostScreen(post: post)
    }
    
    func tableDidTapped(followButton: FollowButton, in community: RMModel.Views.CommunityView) {
        guard let coord = coordinator else {
            return
        }
        
        ContinueIfLogined(on: self, coordinator: coord) {
            followButton.followState = .pending
            self.followService.followUi(to: community)
                .sink { community in
                    followButton.bind(isSubcribed: community.subscribed)
                    self.tableManager.saveNewCommunity(community: community)
                }.store(in: &self.cancellable)
        }
    }
        
    func onMentionTap(in post: RMModel.Views.CommentView, mention: LemmyUserMention) {
        coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: RMModel.Views.PostView
    ) {
        guard let coordinator = coordinator else {
            return
        }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.viewModel.doPostLike(scoreView: scoreView, voteButton: voteButton, for: newVote, post: post)
        }
    }
        
    func onLinkTap(in post: RMModel.Views.PostView, url: URL) {
        coordinator?.goToBrowser(with: url)
    }
    
    func showMore(in post: RMModel.Views.PostView) {
        guard let coordinator = coordinator else {
            return
        }
//        showMoreHandler.showMoreInPost(on: self, coordinator: coordinator, post: post) { updatedPost in
//            self.operateSaveNewPost(viewModel: .init(post: updatedPost))
//        }
    }
    
    func usernameTapped(with mention: LemmyUserMention) {
        coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }

    func postNameTapped(in comment: RMModel.Views.CommentView) {
        coordinator?.goToPostScreen(postId: comment.post.id)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: RMModel.Views.CommentView
    ) {
        guard let coordinator = coordinator else {
            return
        }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.viewModel.doCommentLike(scoreView: scoreView, voteButton: voteButton, for: newVote, comment: comment)
        }
    }
    
    func showContext(in comment: RMModel.Views.CommentView) {
        coordinator?.goToPostAndScroll(to: comment)
    }
    
    func reply(to comment: RMModel.Views.CommentView) {
        coordinator?.goToWriteComment(postSource: comment.post, parrentComment: comment.comment) {
            RMMessagesToast.showSuccessCreateComment()
        }
    }
    
    func onLinkTap(in comment: RMModel.Views.CommentView, url: URL) {
        coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: RMModel.Views.CommentView) {
        guard let coordinator = coordinator else {
            return
        }

        if case .comments(let data) = tableManager.viewModels {
            
            if let comment = data.getElement(by: comment.id) {
                
//                showMoreHandler.showMoreInComment(
//                    on: self,
//                    coordinator: coordinator,
//                    comment: comment
//                ) { updatedComment in
//                    self.operateSaveNewComment(viewModel: .init(comment: updatedComment))
//                }
            }
        }
    }
    
    func tableDidRequestPagination(_ tableDataSource: SearchResultsTableDataSource) {
        guard canTriggerPagination else {
            return
        }
        
        canTriggerPagination = false
        viewModel.doLoadMoreContent(request: .init())
    }
    
    func tableDidSelect(viewModel: SearchResults.Results, indexPath: IndexPath) {
        switch viewModel {
        case .comments:
            break
        case .posts(let data):
            let post = data[indexPath.row]
            self.coordinator?.goToPostScreen(post: post)
        case .communities(let data):
            let community = data[indexPath.row].community
            self.coordinator?.goToCommunityScreen(communityId: community.id, communityName: community.name)
        case .users(let data):
            let user = data[indexPath.row].person
            self.coordinator?.goToProfileScreen(userId: user.id, username: user.name)
        }
    }
}
