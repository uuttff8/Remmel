//
//  ProfileScreenSubscribedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol ProfileScreenAboutViewControllerProtocol: AnyObject {
    func displayProfileSubscribers(viewModel: ProfileScreenAbout.SubscribersLoad.ViewModel)
}

class ProfileScreenSubscribedViewController: UIViewController {
    
    weak var coordinator: ProfileScreenCoordinator?
    private let viewModel: ProfileScreenAboutViewModelProtocol

    private lazy var tableDataSource = ProfileScreenSubscribedTableManager()

    lazy var aboutView = view as? ProfileScreenSubscribedViewController.View

    private var tablePage = 1
    private var state: ProfileScreenAbout.ViewControllerState
    private var canTriggerPagination = true

    init(
        viewModel: ProfileScreenAboutViewModelProtocol,
        initialState: ProfileScreenAbout.ViewControllerState = .loading
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
        let view = ProfileScreenSubscribedViewController.View()
        view.delegate = self
        self.view = view
    }

    private func updateState(newState: ProfileScreenAbout.ViewControllerState) {
        defer {
            state = newState
        }

        if case .loading = newState {
            aboutView?.showActivityIndicatorView()
            return
        }

        if case .loading = self.state {
            aboutView?.hideActivityIndicatorView()
        }

        if case let .result(data) = newState {
            if data.subscribers.isEmpty {
                aboutView?.displayNoData()
            } else {
                aboutView?.updateTableViewData(dataSource: self.tableDataSource)
            }
        }
    }
}

extension ProfileScreenSubscribedViewController: ProfileScreenAboutViewControllerProtocol {
    func displayProfileSubscribers(viewModel: ProfileScreenAbout.SubscribersLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else {
            return
        }

        tableDataSource.viewModels = data.subscribers
        updateState(newState: viewModel.state)
    }
}

extension ProfileScreenSubscribedViewController: ProfileScreenSubscribedViewDelegate {
    func tableDidSelect(
        _ manager: View,
        communityFollower: RMModels.Views.CommunityFollowerView
    ) {
        self.coordinator?.goToCommunityScreen(
            communityId: communityFollower.community.id,
            communityName: communityFollower.community.name
        )
    }
}
