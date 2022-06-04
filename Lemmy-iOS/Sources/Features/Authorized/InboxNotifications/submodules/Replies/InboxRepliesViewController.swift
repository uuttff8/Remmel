//
//  InboxRepliesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxRepliesViewControllerProtocol: AnyObject {
    func displayReplies(viewModel: InboxReplies.LoadReplies.ViewModel)
    func displayNextReplies(viewModel: InboxReplies.LoadReplies.ViewModel)
    func displayCreateCommentLike(viewModel: InboxReplies.CreateCommentLike.ViewModel)
}

final class InboxRepliesViewController: UIViewController {
    
    weak var coordinator: InboxNotificationsCoordinator?
    private let viewModel: InboxRepliesViewModel
    
    private lazy var repliesView = self.view as? InboxRepliesView
    private lazy var tableManager = InboxRepliesTableManager().then {
        $0.delegate = self
    }
    
    private let contentScoreService: ContentScoreServiceProtocol
    private let showMoreService: ShowMoreHandlerServiceProtocol
    
    private var state: InboxReplies.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: InboxRepliesViewModel,
        contentScoreService: ContentScoreServiceProtocol,
        showMoreService: ShowMoreHandlerServiceProtocol,
        initialState: InboxReplies.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.contentScoreService = contentScoreService
        self.showMoreService = showMoreService
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = InboxRepliesView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.doReceiveMessages()
    }
    
    private func updateState(newState: InboxReplies.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            repliesView?.showActivityIndicatorView()
            return
        }

        if case .loading = self.state {
            repliesView?.hideActivityIndicatorView()
        }

        if case .result(let data) = newState {
            if data.isEmpty {
                repliesView?.displayNoData()
            } else {
                repliesView?.updateTableViewData(dataSource: self.tableManager)
            }
        }
    }
}

extension InboxRepliesViewController: InboxRepliesViewControllerProtocol {
    func displayReplies(viewModel: InboxReplies.LoadReplies.ViewModel) {
        guard case .result(let data) = viewModel.state else {
            return
        }
        tableManager.viewModels = data
        updateState(newState: viewModel.state)
    }
    
    func displayNextReplies(viewModel: InboxReplies.LoadReplies.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }
        
        tableManager.viewModels.append(contentsOf: data)
        repliesView?.appendNew(data: data)
        
        if data.isEmpty {
            canTriggerPagination = false
        } else {
            canTriggerPagination = true
        }
    }
    
    func displayCreateCommentLike(viewModel: InboxReplies.CreateCommentLike.ViewModel) {
        self.tableManager.viewModels.updateElementById(viewModel.commentView)
    }
}

extension InboxRepliesViewController: InboxRepliesTableManagerDelegate {
    func tableDidRequestPagination(_ tableManager: InboxRepliesTableManager) {
        guard canTriggerPagination else {
            return
        }
        
        canTriggerPagination = false
        viewModel.doNextLoadReplies(request: .init())
    }
}

extension InboxRepliesViewController: ReplyCellViewDelegate {
    func usernameTapped(with mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        self.coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }

    func postNameTapped(in reply: LMModels.Views.CommentView) {
        self.coordinator?.goToPostScreen(postId: reply.post.id)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        reply: LMModels.Views.CommentView
    ) {
        self.contentScoreService.voteReply(
            scoreView: scoreView,
            voteButton: voteButton,
            for: newVote,
            reply: reply
        )
    }
    
    func showContext(in reply: LMModels.Views.CommentView) {
        self.coordinator?.goToPostAndScroll(to: reply)
    }
    
    func reply(to reply: LMModels.Views.CommentView) {
        self.coordinator?.goToWriteComment(postSource: reply.post, parrentComment: reply.comment) {
            LMMMessagesToast.showSuccessCreateComment()
        }
    }
    
    func onLinkTap(in reply: LMModels.Views.CommentView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
        
    func showMoreAction(in reply: LMModels.Views.CommentView) {
        
        if let reply = self.tableManager.viewModels.getElement(by: reply.id) {
            guard let coordinator = coordinator else {
                return
            }
            self.showMoreService.showMoreInReply(on: self, coordinator: coordinator, reply: reply) { updatedReply in
                self.tableManager.viewModels.updateElementById(updatedReply)
            }
        }
    }
}

extension InboxRepliesViewController: InboxRepliesViewDelegate {
    func inboxRepliesViewDidRequestRefresh() {
        // Small delay for pretty refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewModel.doLoadReplies(request: .init())
        }
    }
}
