//
//  ProfileScreenPostsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenPostViewControllerProtocol: AnyObject {
    func displayProfilePosts(viewModel: ProfileScreenPosts.PostsLoad.ViewModel)
}

class ProfileScreenPostsViewController: UIViewController {
    private let viewModel: ProfileScreenPostsViewModel
    
    private let tableDataSource = ProfileScreenPostsTableDataSource()
    
    lazy var profilePostsView = self.view as? ProfileScreenPostsViewController.View
    
    private var tablePage = 1
    private var state: ProfileScreenPosts.ViewControllerState
    private var canTriggerPagination = true
    
    init(
        viewModel: ProfileScreenPostsViewModel,
        initialState: ProfileScreenPosts.ViewControllerState = .loading
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
        self.view = ProfileScreenPostsViewController.View()
    }
    
    private func updateState(newState: ProfileScreenPosts.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.profilePostsView?.showLoading()
            return
        }

        if case .loading = self.state {
            self.profilePostsView?.hideLoading()
        }

        if case .result = newState {
            self.profilePostsView?.updateTableViewData(dataSource: self.tableDataSource)
        }
    }
}

extension ProfileScreenPostsViewController: ProfileScreenPostViewControllerProtocol {
    func displayProfilePosts(viewModel: ProfileScreenPosts.PostsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data.posts
        self.updateState(newState: viewModel.state)
    }
}
