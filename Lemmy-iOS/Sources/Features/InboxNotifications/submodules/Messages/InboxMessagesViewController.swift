//
//  InboxMessagesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMessagesViewControllerProtocol: AnyObject {
    func displayMessages(viewModel: InboxMessages.LoadMessages.ViewModel)
    func displayNextMessages(viewModel: InboxMessages.LoadMessages.ViewModel)
}

final class InboxMessagesViewController: UIViewController {
    
    weak var coordinator: InboxNotificationsCoordinator?
    private let viewModel: InboxMessagesViewModel
    
    private lazy var messagesView = self.view as! InboxMessagesView
    private lazy var tableManager = InboxMessagesTableManager().then {
        $0.delegate = self
    }
    
    private var state: InboxMessages.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: InboxMessagesViewModel,
        initialState: InboxMessages.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = InboxMessagesView()
        view.delegate = self
        self.view = view
    }
    
    private func updateState(newState: InboxMessages.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.messagesView.showActivityIndicatorView()
            return
        }

        if case .loading = self.state {
            self.messagesView.hideActivityIndicatorView()
        }

        if case .result(let data) = newState {
            if data.isEmpty {
                self.messagesView.displayNoData()
            } else {
                self.messagesView.updateTableViewData(dataSource: self.tableManager)
            }
        }
    }
}

extension InboxMessagesViewController: InboxMessagesViewControllerProtocol {
    func displayMessages(viewModel: InboxMessages.LoadMessages.ViewModel) {
        guard case .result(let data) = viewModel.state else { return }
        self.tableManager.viewModels = data
        updateState(newState: viewModel.state)
    }
    
    func displayNextMessages(viewModel: InboxMessages.LoadMessages.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        
        self.tableManager.viewModels.append(contentsOf: data)
        self.messagesView.appendNew(data: data)
        
        if data.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
}

extension InboxMessagesViewController: InboxMessagesTableManagerDelegate {
    func tableDidRequestPagination(_ tableManager: InboxMessagesTableManager) {
        
    }
}

extension InboxMessagesViewController: InboxMessagesViewDelegate {
    func inboxMessagesViewDidRequestRefresh() {
        // Small delay for pretty refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewModel.doLoadMessages(request: .init())
        }
    }
}

extension InboxMessagesViewController: MessageCellViewDelegate {
    func messageCell(_ cell: MessageCellView, didTapReplyButtonWith id: Int) {
        self.coordinator?.goToWriteMessage(recipientId: id)
    }
    
    func messageCell(_ cell: MessageCellView, didTapUsername username: String) {
        self.coordinator?.goToProfileScreen(userId: nil, username: username)
    }
}
