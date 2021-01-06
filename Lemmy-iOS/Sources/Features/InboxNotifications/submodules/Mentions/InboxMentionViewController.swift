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
}

final class InboxMentionsViewController: UIViewController {
    
    private let viewModel: InboxMentionsViewModel
    
    private lazy var mentionsView = self.view as! InboxMentionsView
    private lazy var tableManager = InboxMentionsTableManager().then {
        $0.delegate = self
    }
    
    private var state: InboxMentions.ViewControllerState
    private var canTriggerPagination = true
    
    init(
        viewModel: InboxMentionsViewModel,
        initialState: InboxMentions.ViewControllerState = .loading
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
        let view = InboxMentionsView()
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
}

extension InboxMentionsViewController: InboxMentionsTableManagerDelegate {
    func tableDidRequestPagination(_ tableManager: InboxMentionsTableManager) {
        
    }
}
