//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostScreenViewControllerProtocol: AnyObject {
    func displayPost(response: PostScreen.PostLoad.ViewModel)
}

class PostScreenViewController: UIViewController {
    private let viewModel: PostScreenViewModelProtocol
    
    private let tableDataSource = PostScreenTableDataSource()
    
    lazy var postScreenView = self.view as! PostScreenViewController.View
    
    private var state: PostScreen.ViewControllerState

    override func loadView() {
        self.view = PostScreenViewController.View()
    }

    init(
        viewModel: PostScreenViewModelProtocol,
        state: PostScreen.ViewControllerState = .loading
    ) {
        self.viewModel = viewModel
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.doPostFetch()
        self.updateState(newState: state)

        postScreenView.presentOnVc = { toPresentVc in
            self.present(toPresentVc, animated: true)
        }

        postScreenView.dismissOnVc = {
            self.dismiss(animated: true)
        }
    }
    
    private func updateState(newState: PostScreen.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.postScreenView.showLoadingView()
            return
        }

        if case .loading = self.state {
            self.postScreenView.hideLoadingView()
        }

        if case .result(let data) = newState {
            self.postScreenView.updateTableViewData(dataSource: self.tableDataSource)
            self.postScreenView.postInfo = data.post
        }
    }
}

extension PostScreenViewController: PostScreenViewControllerProtocol {
    func displayPost(response: PostScreen.PostLoad.ViewModel) {
        guard case let .result(data) = response.state else { return }
        self.tableDataSource.viewModels = data.comments
        self.updateState(newState: response.state)
    }
}
