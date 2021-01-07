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
}

final class InboxRepliesViewController: UIViewController {
    
    weak var coordinator: InboxNotificationsCoordinator?
    private let viewModel: InboxRepliesViewModel
    
    private lazy var repliesView = self.view as! InboxRepliesView
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
        self.view = view
    }
    
    private func updateState(newState: InboxReplies.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.repliesView.showActivityIndicatorView()
            return
        }

        if case .loading = self.state {
            self.repliesView.hideActivityIndicatorView()
        }

        if case .result(let data) = newState {
            if data.isEmpty {
                self.repliesView.displayNoData()
            } else {
                self.repliesView.updateTableViewData(dataSource: self.tableManager)
            }
        }
    }
}

extension InboxRepliesViewController: InboxRepliesViewControllerProtocol {
    func displayReplies(viewModel: InboxReplies.LoadReplies.ViewModel) {
        guard case .result(let data) = viewModel.state else { return }
        self.tableManager.viewModels = data
        updateState(newState: viewModel.state)
    }
    
    func displayNextReplies(viewModel: InboxReplies.LoadReplies.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        
        self.tableManager.viewModels.append(contentsOf: data)
        self.repliesView.appendNew(data: data)
        
        if data.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
}

extension InboxRepliesViewController: InboxRepliesTableManagerDelegate {
    func tableDidRequestPagination(_ tableManager: InboxRepliesTableManager) {
        guard self.canTriggerPagination else { return }
        
        self.canTriggerPagination = false
        self.viewModel.doNextLoadReplies(request: .init())
    }
}

extension InboxRepliesViewController: ReplyCellViewDelegate {
    func usernameTapped(in comment: LemmyModel.ReplyView) {
        self.coordinator?.goToProfileScreen(by: comment.creatorId)
    }
    
    func communityTapped(in comment: LemmyModel.ReplyView) {
        self.coordinator?.goToCommunityScreen(communityId: comment.communityId)
    }
    
    func postNameTapped(in comment: LemmyModel.ReplyView) {
        self.coordinator?.goToPostScreen(postId: comment.postId)
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        comment: LemmyModel.ReplyView
    ) {
        self.contentScoreService.voteReply(
            scoreView: scoreView,
            voteButton: voteButton,
            for: newVote,
            reply: comment,
            completion: { _ in }
        )
    }
    
    func showContext(in comment: LemmyModel.ReplyView) { }
    
    func reply(to comment: LemmyModel.ReplyView) {
        self.coordinator?.goToWriteComment(postId: comment.postId, parrentComment: nil)
    }
    
    func onLinkTap(in comment: LemmyModel.ReplyView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
    
    func onMentionTap(in post: LemmyModel.ReplyView, mention: LemmyMention) {
        self.coordinator?.goToProfileScreen(by: mention.absoluteUsername)
    }
    
    func showMoreAction(in comment: LemmyModel.ReplyView) {
        
    }
}
