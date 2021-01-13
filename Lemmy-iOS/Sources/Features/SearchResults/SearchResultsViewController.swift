//
//  SearchResultsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol SearchResultsViewControllerProtocol: AnyObject {
    func displayContent(viewModel: SearchResults.LoadContent.ViewModel)
    func operateSaveNewPost(viewModel: SearchResults.SavePost.ViewModel)
    func operateSaveNewComment(viewModel: SearchResults.SaveComment.ViewModel)
}

class SearchResultsViewController: UIViewController {
    
    weak var coordinator: FrontPageCoordinator?
    
    private let viewModel: SearchResultsViewModelProtocol
    
    private var state: SearchResults.ViewControllerState
    private let showMoreHandler: ShowMoreHandlerServiceProtocol
    private let followService: CommunityFollowServiceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var tableManager = SearchResultsTableDataSource().then {
        $0.delegate = self
    }
    private lazy var resultsView = self.view as! SearchResultsView
    
    init(
        viewModel: SearchResultsViewModelProtocol,
        state: SearchResults.ViewControllerState = .loading,
        showMoreHandler: ShowMoreHandlerServiceProtocol,
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
        
        self.viewModel.doLoadContent(request: .init())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.coordinator?.free(coordinator)
    }
    
    private func updateState(newState: SearchResults.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.resultsView.showActivityIndicatorView()
        }

        if case .loading = self.state {
            self.resultsView.hideActivityIndicatorView()
        }

        if case .result = newState {
            self.resultsView.updateTableViewData(delegate: tableManager)
        }
    }
}

extension SearchResultsViewController: SearchResultsViewControllerProtocol {
    func displayContent(viewModel: SearchResults.LoadContent.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        
        self.tableManager.viewModels = data
        self.updateState(newState: viewModel.state)
    }
    
    func operateSaveNewPost(viewModel: SearchResults.SavePost.ViewModel) {
        tableManager.saveNewPost(post: viewModel.post)
    }
    
    func operateSaveNewComment(viewModel: SearchResults.SaveComment.ViewModel) {
        tableManager.saveNewComment(comment: viewModel.comment)
    }

}

extension SearchResultsViewController: SearchResultsTableDataSourceDelegate {
    func postCellDidSelected(postId: LemmyModel.PostView.ID) {
        guard case .posts(let posts) = tableManager.viewModels else { return }
        let post = posts.getElement(by: postId).require()
        self.coordinator?.goToPostScreen(post: post)
    }
    
    func tableDidTapped(followButton: FollowButton, in community: LemmyModel.CommunityView) {
        guard let coord = coordinator else { return }
        ContinueIfLogined(on: self, coordinator: coord) {
            self.followService.followUi(followButton: followButton, to: community)
                .sink { (community) in
                    self.tableManager.saveNewCommunity(community: community)
                }.store(in: &self.cancellable)
        }
    }
        
    func onMentionTap(in post: LemmyModel.CommentView, mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func onMentionTap(in post: LemmyModel.PostView, mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        post: LemmyModel.PostView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.viewModel.doPostLike(scoreView: scoreView, voteButton: voteButton, for: newVote, post: post)
        }
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        self.coordinator?.goToProfileScreen(by: post.creatorId)
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        self.coordinator?.goToCommunityScreen(communityId: post.communityId)
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMore(in post: LemmyModel.PostView) {
        guard let coordinator = coordinator else { return }
        self.showMoreHandler.showMoreInPost(on: self, coordinator: coordinator, post: post)
    }
    
    func usernameTapped(with mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        self.coordinator?.goToCommunityScreen(communityName: mention.absoluteName)
    }

    func postNameTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToPostScreen(postId: comment.postId)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.CommentView
    ) {
        guard let coordinator = coordinator else { return }
        
        ContinueIfLogined(on: self, coordinator: coordinator) {
            self.viewModel.doCommentLike(scoreView: scoreView, voteButton: voteButton, for: newVote, comment: comment)
        }
    }
    
    func showContext(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToPostAndScroll(to: comment)
    }
    
    func reply(to comment: LemmyModel.CommentView) {
        coordinator?.goToWriteComment(postId: comment.postId, parrentComment: comment)
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        guard let coordinator = coordinator else { return }
        self.showMoreHandler.showMoreInComment(on: self, coordinator: coordinator, comment: comment)
    }
    
    func tableDidRequestPagination(_ tableDataSource: SearchResultsTableDataSource) {
        // no more yet
    }
    
    func tableDidSelect(viewModel: SearchResults.Results, indexPath: IndexPath) {
        switch viewModel {
        case .comments:
            break
        case .posts(let data):
            let post = data[indexPath.row]
            self.coordinator?.goToPostScreen(post: post)
        case .communities(let data):
            let community = data[indexPath.row]
            self.coordinator?.goToCommunityScreen(communityId: community.id)
        case .users(let data):
            let user = data[indexPath.row]
            self.coordinator?.goToProfileScreen(by: user.id)
        }
    }
}
