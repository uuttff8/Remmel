//
//  ProfileScreenPostsSubViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenPostsSubViewControllerProtocol: AnyObject {
    func displayCourseInfo(viewModel: ProfileScreenPostsSub.PostsLoad.ViewModel)
}

class ProfileScreenPostsSubViewController: UIViewController {
    private let viewModel: ProfileScreenPostsSubViewModel
    
    private let tableDataSource = ProfileScreenPostsTableDataSource()
    
    lazy var profilePostsView = self.view as? ProfileScreenPostsSubViewController.View
    
    private var tablePage = 1
    private var state: ProfileScreenPostsSub.ViewControllerState
    private var canTriggerPagination = true
    
    init(
        viewModel: ProfileScreenPostsSubViewModel,
        initialState: ProfileScreenPostsSub.ViewControllerState = .loading
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
        self.view = ProfileScreenPostsSubViewController.View()
    }
    
    private func updateState(newState: ProfileScreenPostsSub.ViewControllerState) {
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

extension ProfileScreenPostsSubViewController: ProfileScreenPostsSubViewControllerProtocol {
    func displayCourseInfo(viewModel: ProfileScreenPostsSub.PostsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data.posts
        self.updateState(newState: viewModel.state)
    }
}
