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

    private let tableDataSource = ProfileScreenCommentsTableDataSource()

    lazy var commentsPostsView = self.view as? ProfileScreenCommentsViewController.View

    private var tablePage = 1
    private var state: ProfileScreenComments.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: ProfileScreenCommentsViewModel,
        initialState: ProfileScreenComments.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.state = initialState
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
            self.commentsPostsView?.showLoading()
            return
        }

        if case .loading = self.state {
            self.commentsPostsView?.hideLoading()
        }

        if case .result = newState {
            self.commentsPostsView?.updateTableViewData(dataSource: self.tableDataSource)
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
