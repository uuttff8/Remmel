//
//  CommunitiesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CommunitiesPreviewViewControllerProtocol: AnyObject {
    func displayCommunities(viewModel: CommunitiesPreview.CommunitiesLoad.ViewModel)
}

class CommunitiesPreviewViewController: UIViewController {
    
    weak var coordinator: CommunitiesCoordinator?
    private let viewModel: CommunitiesPreviewViewModel
    
    private lazy var previewView = self.view as! CommunitiesPreviewView
    
    private lazy var tableManager = CommunitiesPreviewDataSource().then {
        $0.delegate = self
    }
    
    private let followService: CommunityFollowServiceProtocol
    private var state: CommunitiesPreview.ViewControllerState
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        viewModel: CommunitiesPreviewViewModel,
        state: CommunitiesPreview.ViewControllerState = .loading,
        followService: CommunityFollowServiceProtocol
    ) {
        self.viewModel = viewModel
        self.state = state
        self.followService = followService
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = CommunitiesPreviewView()
        view.delegate = self
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Communities"

        viewModel.doLoadCommunities(request: .init())
    }
    
    private func updateState(newState: CommunitiesPreview.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.previewView.showLoadingView()
            return
        }

        if case .loading = self.state {
            self.previewView.hideLoadingView()
        }

        if case .result = newState {
            self.previewView.updateTableViewData(dataSource: self.tableManager)
        }
    }
}

extension CommunitiesPreviewViewController: CommunitiesPreviewViewControllerProtocol {
    func displayCommunities(viewModel: CommunitiesPreview.CommunitiesLoad.ViewModel) {
        guard case .result(let data) = viewModel.state else { return }
        
        self.tableManager.viewModels = data
        self.updateState(newState: viewModel.state)
    }
}

extension CommunitiesPreviewViewController: CommunitiesPreviewTableDataSourceDelegate {
    func tableDidTapped(followButton: FollowButton, in community: LemmyModel.CommunityView) {
        
        guard let coord = coordinator else { return }
        ContinueIfLogined(on: self, coordinator: coord) {
            self.followService.followUi(followButton: followButton, to: community)
                .sink { (community) in
                    self.tableManager.viewModels.updateElementById(community)
                }.store(in: &self.cancellable)
        }
    }
    
    func tableDidSelect(community: LemmyModel.CommunityView) {
        self.coordinator?.goToCommunityScreen(communityId: community.id)
    }
}

extension CommunitiesPreviewViewController: CommunitiesPreviewViewDelagate {
    func previewViewDidRequestRefresh() {
        // Small delay for pretty refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewModel.doLoadCommunities(request: .init())
        }
    }
}

extension CommunitiesPreviewViewController: TabBarReselectHandling {
    func handleReselect() {
        self.previewView.scrollToTop()
    }
}
