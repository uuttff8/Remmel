//
//  ProfileScreenCommentsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenCommentsViewControllerProtocol: AnyObject {
    func displayProfileComments(viewModel: ProfileScreenComments.CommentsLoad.ViewModel)
}

class ProfileScreenCommentsViewController: UIViewController {
    private let viewModel: ProfileScreenCommentsViewModel
    
    weak var coordinator: ProfileScreenCoordinator?

    private lazy var tableDataSource = ProfileScreenCommentsTableDataSource().then {
        $0.delegate = self
    }
    private let showMoreHandler: ShowMoreHandlerServiceProtocol

    lazy var commentsPostsView = self.view as? ProfileScreenCommentsViewController.View

    private var tablePage = 1
    private var state: ProfileScreenComments.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: ProfileScreenCommentsViewModel,
        initialState: ProfileScreenComments.ViewControllerState = .loading,
        showMoreHandler: ShowMoreHandlerServiceProtocol
    ) {
        self.viewModel = viewModel
        self.state = initialState
        self.showMoreHandler = showMoreHandler
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateState(newState: self.state)
    }

    override func loadView() {
        self.view = ProfileScreenCommentsViewController.View()
    }

    private func updateState(newState: ProfileScreenComments.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.commentsPostsView?.showLoadingIndicator()
            return
        }

        if case .loading = self.state {
            self.commentsPostsView?.hideLoadingIndicator()
        }

        if case .result(let data) = newState {
            if data.comments.isEmpty {
                self.commentsPostsView?.displayNoData()
            } else {
                self.commentsPostsView?.updateTableViewData(dataSource: self.tableDataSource)
            }
        }
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsViewControllerProtocol {
    func displayProfileComments(viewModel: ProfileScreenComments.CommentsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data.comments
        self.updateState(newState: viewModel.state)
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsTableDataSourceDelegate {
    func usernameTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToProfileScreen(by: comment.creatorId)
    }
    
    func communityTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToCommunityScreen(communityId: comment.communityId)
    }
    
    func postNameTapped(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToPostScreen(postId: comment.postId)
    }
    
    func upvote(
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
    
    func downvote(
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
        // no more yet
    }
    
    func reply(to comment: LemmyModel.CommentView) {
        // no more yet
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        self.showMoreHandler.showMoreInComment(on: self, comment: comment)
    }
}
