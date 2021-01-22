//
//  ProfileScreenAboutViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenAboutViewControllerProtocol: AnyObject {
    func displayProfileSubscribers(viewModel: ProfileScreenAbout.SubscribersLoad.ViewModel)
}

class ProfileScreenAboutViewController: UIViewController {
    
    weak var coordinator: ProfileScreenCoordinator?
    private let viewModel: ProfileScreenAboutViewModelProtocol

    private lazy var tableDataSource = ProfileScreenAboutTableManager()

    lazy var aboutView = self.view as? ProfileScreenAboutViewController.View

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
        let view = ProfileScreenAboutViewController.View()
        view.delegate = self
        self.view = view
    }

    private func updateState(newState: ProfileScreenAbout.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.aboutView?.showActivityIndicatorView()
            return
        }

        if case .loading = self.state {
            self.aboutView?.hideActivityIndicatorView()
        }

        if case .result = newState {
            self.aboutView?.updateTableViewData(dataSource: self.tableDataSource)
        }
    }
}

extension ProfileScreenAboutViewController: ProfileScreenAboutViewControllerProtocol {
    func displayProfileSubscribers(viewModel: ProfileScreenAbout.SubscribersLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data.subscribers
        self.updateState(newState: viewModel.state)
    }
}

extension ProfileScreenAboutViewController: ProfileScreenAboutViewDelegate {
    func tableDidSelect(
        _ manager: View,
        communityFollower: LMModels.Views.CommunityFollowerView
    ) {
        self.coordinator?.goToCommunityScreen(
            communityId: communityFollower.community.id,
            communityName: communityFollower.community.name
        )
    }
}
