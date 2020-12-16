//
//  CommunitiesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

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
    
    private var state: CommunitiesPreview.ViewControllerState
    
    init(
        viewModel: CommunitiesPreviewViewModel,
        state: CommunitiesPreview.ViewControllerState = .loading
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
        let view = CommunitiesPreviewView()
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
    func tableDidSelect(community: LemmyModel.CommunityView) {
        self.coordinator?.goToCommunityScreen(communityId: community.id)
    }
}
