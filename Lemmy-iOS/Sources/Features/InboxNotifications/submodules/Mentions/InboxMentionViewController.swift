//
//  InboxMentionViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMentionsViewControllerProtocol: AnyObject {
    func displayMentions(viewModel: InboxMentions.LoadMentions.ViewModel)
    func displayNextMentions(viewModel: InboxMentions.LoadMentions.ViewModel)
}

final class InboxMentionsViewController: UIViewController {
    
    weak var coordinator: InboxNotificationsCoordinator?
    private let viewModel: InboxMentionsViewModel
    
    private lazy var mentionsView = self.view as! InboxMentionsView
    private lazy var tableManager = InboxMentionsTableManager().then {
        $0.delegate = self
    }
    
    private let contentScoreService: ContentScoreServiceProtocol
    private let showMoreService: ShowMoreHandlerServiceProtocol
    
    private var state: InboxMentions.ViewControllerState
    private var canTriggerPagination = true
    
    init(
        viewModel: InboxMentionsViewModel,
        contentScoreService: ContentScoreServiceProtocol,
        showMoreService: ShowMoreHandlerServiceProtocol,
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
    
    private func updateState(newState: InboxMentions.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.mentionsView.showActivityIndicatorView()
            return
        }

        if case .loading = self.state {
            self.mentionsView.hideActivityIndicatorView()
        }

        if case .result(let data) = newState {
            if data.isEmpty {
                self.mentionsView.displayNoData()
            } else {
                self.mentionsView.updateTableViewData(dataSource: self.tableManager)
            }
        }
    }
}

extension InboxMentionsViewController: InboxMentionsViewControllerProtocol {
    func displayMentions(viewModel: InboxMentions.LoadMentions.ViewModel) {
        guard case .result(let data) = viewModel.state else { return }
        self.tableManager.viewModels = data
        updateState(newState: viewModel.state)
    }
    
    func displayNextMentions(viewModel: InboxMentions.LoadMentions.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        
        self.tableManager.viewModels.append(contentsOf: data)
        self.mentionsView.appendNew(data: data)
        
        if data.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
}

extension InboxMentionsViewController: InboxMentionsTableManagerDelegate {
    func tableDidRequestPagination(_ tableManager: InboxMentionsTableManager) {
        guard self.canTriggerPagination else { return }
        
        self.canTriggerPagination = false
        self.viewModel.doNextLoadMentions(request: .init())
    }
}

extension InboxMentionsViewController: UserMentionCellViewDelegate {    
    func usernameTapped(with mention: LemmyUserMention) {
        self.coordinator?.goToProfileScreen(userId: mention.absoluteId, username: mention.absoluteUsername)
    }
    
    func communityTapped(with mention: LemmyCommunityMention) {
        self.coordinator?.goToCommunityScreen(communityId: mention.absoluteId, communityName: mention.absoluteName)
    }

    func postNameTapped(in userMention: LMModels.Views.UserMentionView) {
        
    }
    
    func voteContent(
        scoreView: VoteButtonsWithScoreView,
        voteButton: VoteButton,
        newVote: LemmyVoteType,
        userMention: LMModels.Views.UserMentionView
    ) {
        self.contentScoreService.voteUserMention(
            scoreView: scoreView,
            voteButton: voteButton,
            for: newVote,
            userMention: userMention,
            completion: { _ in } // FIXIT: CommentContentTableCell should take LMModels.Source.Comment, not view
        )
    }
    
    func showContext(in comment: LMModels.Views.UserMentionView) {
        
    }
    
    func reply(to userMention: LMModels.Views.UserMentionView) {
        self.coordinator?.goToWriteComment(postSource: userMention.post, parrentComment: userMention.comment)
    }
    
    func onLinkTap(in userMention: LMModels.Views.UserMentionView, url: URL) {
        self.coordinator?.goToBrowser(with: url)
    }
        
    func showMoreAction(in userMention: LMModels.Views.UserMentionView) {
        guard let coordinator = coordinator else { return }
        self.showMoreService.showMoreInUserMention(on: self, coordinator: coordinator, mention: userMention)
    }
}

extension InboxMentionsViewController: InboxMentionsViewDelegate {
    func inboxMentionsViewDidRequestRefresh() {
        // Small delay for pretty refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewModel.doLoadMentions(request: .init())
        }
    }
}
