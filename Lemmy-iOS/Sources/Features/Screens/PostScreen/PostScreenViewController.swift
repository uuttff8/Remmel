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

class PostScreenViewController: UIViewController, Containered {
    private let viewModel: PostScreenViewModelProtocol
        
    lazy var postScreenView = PostScreenViewController.View().then {
        $0.delegate = self
    }
    
    let foldableCommentsViewController = FoldableLemmyCommentsViewController()
    
    private var state: PostScreen.ViewControllerState

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
        
        self.add(asChildViewController: foldableCommentsViewController)
        
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
            self.postScreenView.bind(with: data.post)
            self.foldableCommentsViewController.showComments(with: data.comments)
            self.foldableCommentsViewController.setupHeaderView(postScreenView)
        }
    }
}

extension PostScreenViewController: PostScreenViewControllerProtocol {
    func displayPost(response: PostScreen.PostLoad.ViewModel) {
//        guard case let .result(data) = response.state else { return }
                
//        self.tableDataSource.viewModels = data.comments
        self.updateState(newState: response.state)
    }
}

extension PostScreenViewController: PostScreenViewDelegate {
    
}
