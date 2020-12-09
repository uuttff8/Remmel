//
//  SearchResultsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol SearchResultsViewControllerProtocol: AnyObject {
    func displayContent(viewModel: SearchResults.LoadContent.ViewModel)
}

class SearchResultsViewController: UIViewController {
    
    weak var coordinator: FrontPageCoordinator?
    
    private let viewModel: SearchResultsViewModelProtocol
    
    private var state: SearchResults.ViewControllerState
    
    private lazy var tableManager = SearchResultsTableDataSource(delegateImpl: self)
    private lazy var resultsView = self.view as! SearchResultsView
    
    init(
        viewModel: SearchResultsViewModelProtocol,
        state: SearchResults.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.state = state
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
}

extension SearchResultsViewController: SearchResultsTableDataSourceDelegate {
    func tableDidSelect(viewModel: SearchResults.Results) {
        
    }
    
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        
    }
    
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView) {
        
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        
    }
    
    func showMore(in post: LemmyModel.PostView) {
        
    }
    
    func usernameTapped(in comment: LemmyModel.CommentView) {
        
    }
    
    func communityTapped(in comment: LemmyModel.CommentView) {
        
    }
    
    func postNameTapped(in comment: LemmyModel.CommentView) {
        
    }
    
    func upvote(voteButton: VoteButtonsWithScoreView, newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        
    }
    
    func downvote(voteButton: VoteButtonsWithScoreView, newVote: LemmyVoteType, comment: LemmyModel.CommentView) {
        
    }
    
    func showContext(in comment: LemmyModel.CommentView) {
        
    }
    
    func reply(to comment: LemmyModel.CommentView) {
        
    }
    
    func onLinkTap(in comment: LemmyModel.CommentView, url: URL) {
        
    }
    
    func showMoreAction(in comment: LemmyModel.CommentView) {
        
    }
    
    func tableDidRequestPagination(_ tableDataSource: SearchResultsTableDataSource) {
        
    }
}
