//
//  InboxMentionViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMServices
import RMFoundation

protocol InboxMentionsViewControllerProtocol: AnyObject {
    func displayMentions(viewModel: InboxMentions.LoadMentions.ViewModel)
    func displayNextMentions(viewModel: InboxMentions.LoadMentions.ViewModel)
    func displayCreateCommentLike(viewModel: InboxMentions.CreateCommentLike.ViewModel)
}

final class InboxMentionsViewController: UIViewController {
    
    weak var coordinator: InboxNotificationsCoordinator?
    private let viewModel: InboxMentionsViewModel
    
    private lazy var mentionsView = self.view as? InboxMentionsView
    private lazy var tableManager = InboxMentionsTableManager().then {
        $0.delegate = self
    }
    
    private let contentScoreService: ContentScoreServiceProtocol
    private let showMoreService: ShowMoreHandlerService
    
    private var state: InboxMentions.ViewControllerState
    private var canTriggerPagination = true
    
    init(
        viewModel: InboxMentionsViewModel,
        contentScoreService: ContentScoreServiceProtocol,
        showMoreService: ShowMoreHandlerService,
        initialState: InboxMentions.ViewControllerState = .loading
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
        let view = InboxMentionsView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.doReceiveMessages()
    }
    
    private func updateState(newState: InboxMentions.ViewControllerState) {
        defer {
            state = newState
        }

        if case .loading = newState {
            mentionsView?.showActivityIndicatorView()
            return
        }

        if case .loading = state {
            mentionsView?.hideActivityIndicatorView()
        }

        if case .result(let data) = newState {
            if data.isEmpty {
                mentionsView?.displayNoData()
            } else {
                mentionsView?.updateTableViewData(dataSource: self.tableManager)
            }
        }
    }
}

extension InboxMentionsViewController: InboxMentionsViewControllerProtocol {
    func displayCreateCommentLike(viewModel: InboxMentions.CreateCommentLike.ViewModel) {
        var comments = self.tableManager.viewModels.map(\.comment)
        comments.updateElementById(viewModel.commentView.comment)
    }
    
    func displayMentions(viewModel: InboxMentions.LoadMentions.ViewModel) {
        guard case .result(let data) = viewModel.state else {
            return
        }

        tableManager.viewModels = data
        updateState(newState: viewModel.state)
    }
    
    func displayNextMentions(viewModel: InboxMentions.LoadMentions.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }
        
        tableManager.viewModels.append(contentsOf: data)
        mentionsView?.appendNew(data: data)
        
        if data.isEmpty {
            canTriggerPagination = false
        } else {
            canTriggerPagination = true
        }
    }
}

extension InboxMentionsViewController: InboxMentionsTableManagerDelegate {
    func tableDidRequestPagination(_ tableManager: InboxMentionsTableManager) {
        guard canTriggerPagination else {
            return
        }
        
        canTriggerPagination = false
        viewModel.doNextLoadMentions(request: .init())
    }
}

extension InboxMentionsViewController: UserMentionCellViewDelegate {
    func usernameTapped(with mention: LemmyUserMention) {
        coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }

    func postNameTapped(in userMention: RMModels.Views.PersonMentionView) { }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        userMention: RMModels.Views.PersonMentionView
    ) {
        scoreView.setVoted(voteButton: voteButton, to: newVote)
        contentScoreService.voteUserMention(for: newVote, userMention: userMention)
    }
    
    func showContext(in comment: RMModels.Views.PersonMentionView) { }
    
    func reply(to userMention: RMModels.Views.PersonMentionView) {
        coordinator?.goToWriteComment(postSource: userMention.post, parrentComment: userMention.comment) {
            RMMessagesToast.showSuccessCreateComment()
        }
    }
    
    func onLinkTap(in userMention: RMModels.Views.PersonMentionView, url: URL) {
        coordinator?.goToBrowser(with: url)
    }
        
    func showMoreAction(in userMention: RMModels.Views.PersonMentionView) {
        guard let coordinator = coordinator else {
            return
        }

        if let userMention = tableManager.viewModels.getElement(by: userMention.id) {
//            showMoreService.showMoreInUserMention(on: self, coordinator: coordinator, mention: userMention)
        }
    }
}

extension InboxMentionsViewController: InboxMentionsViewDelegate {
    func inboxMentionsViewDidRequestRefresh() {
        // Small delay for pretty refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in

            self?.viewModel.doLoadMentions(request: .init())
        }
    }
}
