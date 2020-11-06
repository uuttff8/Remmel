//
//  FrontPageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

class FrontPageViewController: UIViewController {

    weak var coordinator: FrontPageCoordinator?

    let navBar = LemmyFrontPageNavBar()
    let headerSegmentView = FrontPageHeaderView(contentSelected: LemmyContentType.comments)

    private lazy var toolbar: UIToolbar = {
        let tool = UIToolbar()
        return tool
    }()

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

    // at init always all
    var currentFeedType: LemmyPostListingType = LemmyPostListingType.all {
        didSet {
            print(currentFeedType)
        }
    }

    var currentViewController: UIViewController! {
        didSet {
            if oldValue != currentViewController {
                self.coordinator?.switchViewController()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        self.headerSegmentView.delegate = self

        setupToolbar()
        setupNavigationItem()
        setupContainered()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.currentViewController = coordinator?.postsViewController
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

extension FrontPageViewController: FrontPageHeaderCellDelegate {
    func contentTypeChanged(to content: LemmyContentType) {
        self.currentContentType = content
    }

    func feedTypeChanged(to feed: LemmyPostListingType) {
        self.currentFeedType = feed
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
