//
//  FrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

protocol FrontPageViewControllerProtocol: AnyObject {
    func displayAutorizationAlert()
    func displayProfileScreen(viewModel: FrontPage.ProfileAction.ViewModel)
}

class FrontPageViewController: UIViewController {

    weak var coordinator: FrontPageCoordinator?
    
    private let viewModel: FrontPageViewModelProtocol
    
    private lazy var navBar: LemmyFrontPageNavBar = {
        let bar = LemmyFrontPageNavBar()
        bar.searchBar.delegate = self
        bar.onProfileIconTap = {
            self.viewModel.doNavBarProfileAction()
        }
        return bar
    }()
    private let headerSegmentView = FrontPageHeaderView(contentSelected: LemmyContentType.comments)

    private lazy var toolbar = UIToolbar()
    
    // at init always posts
    var currentContentType: LemmyContentType = LemmyContentType.posts {
        didSet {
            print(currentContentType)

            switch currentContentType {
            case .comments:
                currentViewController = coordinator?.commentsViewController
            case .posts:
                currentViewController = coordinator?.postsViewController
            }
        }
    }

    var currentViewController: UIViewController! {
        didSet {
            if oldValue != currentViewController {
                self.coordinator?.switchViewController()
            }
        }
    }
    
    init(viewModel: FrontPageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        self.headerSegmentView.delegate = self
        
        setupToolbar()
        setupNavigationItem()
        setupContainered()
        
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.currentViewController = coordinator?.postsViewController
    }
    
    func configureSearchView(_ searchView: UIView) {
        self.view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupToolbar() {
        let barButtonItem = UIBarButtonItem(customView: headerSegmentView)

        self.view.addSubview(toolbar)
        self.toolbar.setItems([barButtonItem], animated: true)
    }

    private func setupContainered() {
        guard let coordinator = coordinator else { return }
        setupContaineredView(for: coordinator.postsViewController)
        setupContaineredView(for: coordinator.commentsViewController)
    }

    private func setupContaineredView(for viewController: UIViewController) {
        self.view.insertSubview(viewController.view, belowSubview: self.toolbar)
        self.addChild(viewController)
        viewController.didMove(toParent: self)

        self.addContainerViewConstraints(viewController: viewController, containerView: self.view)
    }

    private func addContainerViewConstraints(viewController: UIViewController, containerView: UIView) {
        viewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.toolbar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    private func setupNavigationItem() {
        navigationItem.titleView = navBar
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.toolbar.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FrontPageViewController: FrontPageViewControllerProtocol {
    func displayAutorizationAlert() {
        UIAlertController.showLoginOrRegisterAlert(
            on: self,
            onLogin: {
                self.coordinator?.goToLoginScreen(authMethod: .login)
            }, onRegister: {
                self.coordinator?.goToLoginScreen(authMethod: .register)
            })
    }
    
    func displayProfileScreen(viewModel: FrontPage.ProfileAction.ViewModel) {
        self.coordinator?.goToProfileScreen(by: viewModel.user.name)
    }
}

extension FrontPageViewController: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
    }
}

extension FrontPageViewController: TabBarReselectHandling {
    func handleReselect() {
        if let currentVc = currentViewController as? PostsFrontPageViewController {
            currentVc.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else if let currentVc = currentViewController as? CommentsFrontPageViewController {
            currentVc.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

extension FrontPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text, !query.isEmpty else {
            coordinator?.hideSearchIfNeeded()
            return
        }
        
        coordinator?.showSearchIfNeeded(with: searchText)
    }
}
