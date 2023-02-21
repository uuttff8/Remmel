//
//  ProfileScreenCommentsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMServices
import RMModels
import RMFoundation

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
    private let showMoreHandler: ShowMoreHandlerService
    private let contentScoreService: ContentScoreServiceProtocol

    lazy var commentsPostsView = view as? ProfileScreenCommentsViewController.View

    private var tablePage = 1
    private var state: ProfileScreenComments.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: ProfileScreenCommentsViewModel,
        initialState: ProfileScreenComments.ViewControllerState = .loading,
        showMoreHandler: ShowMoreHandlerService,
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
        updateState(newState: state)
    }

    private func updateState(newState: ProfileScreenComments.ViewControllerState) {
        defer {
            state = newState
        }

        if case .loading = newState {
            commentsPostsView?.showLoadingIndicator()
            return
        }

        if case .loading = state {
            commentsPostsView?.hideLoadingIndicator()
        }

        if case .result(let data) = newState {
            if data.comments.isEmpty {
                commentsPostsView?.displayNoData()
            } else {
                commentsPostsView?.updateTableViewData(dataSource: self.tableDataSource)
            }
        }
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsViewControllerProtocol {
    func displayProfileComments(viewModel: ProfileScreenComments.CommentsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }
        tableDataSource.viewModels = data.comments
        updateState(newState: viewModel.state)
    }
    
    func displayNextComments(viewModel: ProfileScreenComments.NextProfileCommentsLoad.ViewModel) {
        guard case let .result(comments) = viewModel.state else {
            return
        }
        
        tableDataSource.viewModels.append(contentsOf: comments)
        commentsPostsView?.appendNew(data: comments)
        
        if comments.isEmpty {
            canTriggerPagination = false
        } else {
            canTriggerPagination = true
        }
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsTableDataSourceDelegate {
    func tableDidRequestPagination(_ tableDataSource: ProfileScreenCommentsTableDataSource) {
        guard canTriggerPagination, let commentsPostsView = commentsPostsView else {
            return
        }
        
        canTriggerPagination = false
        viewModel.doNextCommentsFetch(request: .init(sortType: commentsPostsView.sortType))
    }
        
    func usernameTapped(with mention: LemmyUserMention) {
        coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }
    
    func postNameTapped(in comment: RMModels.Views.CommentView) {
        coordinator?.goToPostScreen(postId: comment.post.id)
    }
        
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: RMModels.Views.CommentView
    ) {
        guard let coordinator = coordinator else {
            return
        }
        
        ContinueIfLogined(on: self, coordinator: coordinator) { [weak self] in
            
            scoreView.setVoted(voteButton: voteButton, to: newVote)
            self?.contentScoreService.voteComment(
                for: newVote,
                comment: comment
            )
        }
    }
    
    func showContext(in comment: RMModels.Views.CommentView) {
        self.coordinator?.goToPostAndScroll(to: comment)
    }
    
    func reply(to comment: RMModels.Views.CommentView) {
        self.coordinator?.goToWriteComment(postSource: comment.post, parrentComment: comment.comment) {
            RMMessagesToast.showSuccessCreateComment()
        }
    }
    
    func onLinkTap(in comment: RMModels.Views.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func showMoreAction(in comment: RMModels.Views.CommentView) {
        guard let coordinator = coordinator else {
            return
        }

        if let index = tableDataSource.viewModels.getElementIndex(by: comment.id) {
//            showMoreHandler.showMoreInComment(
//                on: self,
//                coordinator: coordinator,
//                comment: tableDataSource.viewModels[index]
//            ) { [weak self] updatedComment in
//
//                self?.tableDataSource.viewModels.updateElementById(updatedComment)
//            }
            
        }
    }
}

extension ProfileScreenCommentsViewController: ProfileScreenCommentsViewDelegate {
    func profileScreenComments(_ view: View, didPickedNewSort type: RMModels.Others.SortType) {
        commentsPostsView?.showLoadingIndicator()
        commentsPostsView?.deleteAllContent()
        viewModel.doProfileCommentsFetch(request: .init(sortType: type))
    }
    
    func profileScreenPostsViewDidPickerTapped(toVc: UIViewController) {
        present(toVc, animated: true)
    }
}
