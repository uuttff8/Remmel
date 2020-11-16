//
//  ProfileScreenPostsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

protocol ProfileScreenPostViewControllerProtocol: AnyObject {
    func displayProfilePosts(viewModel: ProfileScreenPosts.PostsLoad.ViewModel)
    func displayNextPosts(viewModel: CommunityScreen.NextCommunityPostsLoad.ViewModel)
}

class ProfileScreenPostsViewController: UIViewController {
    private let viewModel: ProfileScreenPostsViewModel
    
    private lazy var tableDataSource = PostsTableDataSource().then {
        $0.delegate = self
    }
    
    lazy var profilePostsView = self.view as! ProfileScreenPostsViewController.View
    
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
        let view = ProfileScreenPostsViewController.View(tableViewDelegate: tableDataSource)
        view.delegate = self
        self.view = view
    }
    
    private func updateState(newState: ProfileScreenPosts.ViewControllerState) {
        defer {
            self.state = newState
        }

        if case .loading = newState {
            self.profilePostsView.showLoading()
            return
        }

        if case .loading = self.state {
            self.profilePostsView.hideLoading()
        }

        if case .result = newState {
            self.profilePostsView.updateTableViewData(dataSource: self.tableDataSource)
        }
    }
}

extension ProfileScreenPostsViewController: ProfileScreenPostViewControllerProtocol {
    func displayProfilePosts(viewModel: ProfileScreenPosts.PostsLoad.ViewModel) {
        guard case let .result(data) = viewModel.state else { return }
        self.tableDataSource.viewModels = data.posts
        self.updateState(newState: viewModel.state)
    }
    
    func displayNextPosts(viewModel: CommunityScreen.NextCommunityPostsLoad.ViewModel) {
        guard case let .result(posts) = viewModel.state else { return }
        
        self.tableDataSource.viewModels.append(contentsOf: posts)
        self.profilePostsView.appendNew(data: posts)
        
        if posts.isEmpty {
            self.canTriggerPagination = false
        } else {
            self.canTriggerPagination = true
        }
    }
}

extension ProfileScreenPostsViewController: ProfileScreenPostsViewDelegate {
    func profileScreenPostsViewDidPickerTapped(toVc: UIViewController) {
        self.present(toVc, animated: true)
    }
}

extension ProfileScreenPostsViewController: PostsTableDataSourceDelegate {
    func upvote(post: LemmyModel.PostView) {
        // todo
    }
    
    func downvote(post: LemmyModel.PostView) {
        // todo
    }
    
    func usernameTapped(in post: LemmyModel.PostView) {
        // todo
    }
    
    func communityTapped(in post: LemmyModel.PostView) {
        // todo
    }
    
    func onLinkTap(in post: LemmyModel.PostView, url: URL) {
        let safariVc = SFSafariViewController(url: url)
        safariVc.delegate = self
        present(safariVc, animated: true)
    }
    
    func tableDidRequestPagination(_ tableDataSource: PostsTableDataSource) {
        guard self.canTriggerPagination else { return }
        
        self.canTriggerPagination = false
        self.viewModel.doNextPostsFetch(request: .init(contentType: profilePostsView.contentType))
    }
    
    func tableDidSelect(post: LemmyModel.PostView) {
        
    }
}

extension ProfileScreenPostsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
