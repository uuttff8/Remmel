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
    func displayNextComments(viewModel: ProfileScreenComments.NextProfileCommentsLoad.ViewModel)
}

class ProfileScreenCommentsViewController: UIViewController {
    
    private let viewModel: ProfileScreenCommentsViewModel
    
    weak var coordinator: ProfileScreenCoordinator?

    private lazy var tableDataSource = ProfileScreenCommentsTableDataSource().then {
        $0.delegate = self
    }
    private let showMoreHandler: ShowMoreHandlerServiceProtocol
    private let contentScoreService: ContentScoreServiceProtocol

    lazy var commentsPostsView = self.view as! ProfileScreenCommentsViewController.View

    private var tablePage = 1
    private var state: ProfileScreenComments.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: ProfileScreenCommentsViewModel,
        initialState: ProfileScreenComments.ViewControllerState = .loading,
        showMoreHandler: ShowMoreHandlerServiceProtocol,
        contentScoreService: ContentScoreServiceProtocol
    ) {
        self.viewModel = viewModel
        self.state = initialState
        self.showMoreHandler = showMoreHandler
        self.contentScoreService = contentScoreService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = ProfileScreenCommentsViewController.View(tableViewManager: tableDataSource)
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateState(newState: self.state)
    }

    private func updateState(newState: ProfileScreenComments.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.commentsPostsView.showLoadingIndicator()
            return
        }

        if case .loading = self.state {
            self.commentsPostsView.hideLoadingIndicator()
        }

        if case .result(let data) = newState {
            if data.comments.isEmpty {
                self.commentsPostsView.displayNoData()
            } else {
                self.commentsPostsView.updateTableViewData(dataSource: self.tableDataSource)
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
    
    func displayNextComments(viewModel: ProfileScreenComments.NextProfileCommentsLoad.ViewModel) {
        guard case let .result(comments) = viewModel.state else { return }
        
        self.tableDataSource.viewModels.append(contentsOf: comments)
        self.commentsPostsView.appendNew(data: comments)
        
        if comments.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsTableDataSourceDelegate {
    func tableDidRequestPagination(_ tableDataSource: ProfileScreenCommentsTableDataSource) {
        guard self.canTriggerPagination else { return }
        
        self.canTriggerPagination = false
        self.viewModel.doNextCommentsFetch(request: .init(sortType: commentsPostsView.sortType))
    }
        
    func usernameTapped(with mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        self.coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
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
            self.contentScoreService.voteComment(
                scoreView: scoreView,
                voteButton: voteButton,
                for: newVote,
                comment: comment
            ) { (comment) in
                self.tableDataSource.viewModels.updateElementById(comment)
            }
        }
    }
    
    func showContext(in comment: LemmyModel.CommentView) {
        self.coordinator?.goToPostAndScroll(to: comment)
    }
    
    func reply(to comment: LemmyModel.CommentView) {
        self.coordinator?.goToWriteComment(postId: comment.postId, parrentComment: comment)
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        guard let coordinator = coordinator else { return }
        self.showMoreHandler.showMoreInComment(on: self, coordinator: coordinator, comment: comment)
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsViewDelegate {
    func profileScreenComments(_ view: View, didPickedNewSort type: LemmySortType) {
        self.commentsPostsView.showLoadingIndicator()
        self.commentsPostsView.deleteAllContent()
        self.viewModel.doProfileCommentsFetch(request: .init(sortType: type))
    }
    
    func profileScreenPostsViewDidPickerTapped(toVc: UIViewController) {
        self.present(toVc, animated: true)
    }
}
