//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostScreenScrollablePage: AnyObject {
    var scrollViewDelegate: UIScrollViewDelegate? { get set }
    var contentInset: UIEdgeInsets { get set }
    var contentOffset: CGPoint { get set }
    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior { get set }
}

protocol PostScreenViewControllerProtocol: AnyObject {
    func displayPost(response: PostScreen.PostLoad.ViewModel)
}

class PostScreenViewController: UIViewController, Containered {
    private let viewModel: PostScreenViewModelProtocol
    
    // Due to lazy initializing we should know actual values to update inset/offset of new scrollview
    private var lastKnownScrollOffset: CGFloat = 0
    private var lastKnownHeaderHeight: CGFloat = 0
    
    private let tableDataSource = PostScreenTableDataSource()
    
    lazy var postScreenView = self.view as! PostScreenViewController.View
    let foldableCommentsViewController = FoldableLemmyCommentsViewController()
    
    private var state: PostScreen.ViewControllerState

    override func loadView() {
        let view = PostScreenViewController.View()
        view.delegate = self
        self.view = view
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
    
    // Update content inset (to make header visible)
    private func updateContentInset(headerHeight: CGFloat) {
        // Update contentInset for each page
        let viewController = foldableCommentsViewController

        viewController.contentInset = UIEdgeInsets(
            top: headerHeight,
            left: viewController.contentInset.left,
            bottom: viewController.contentInset.bottom,
            right: viewController.contentInset.right
        )
        viewController.scrollViewDelegate = self

        viewController.view.setNeedsLayout()
        viewController.view.layoutIfNeeded()
        
        viewController.contentInsetAdjustmentBehavior = .never
    }
    
    // Update content offset (to update appearance and offset on each tab)
    private func updateContentOffset(scrollOffset: CGFloat) {
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height
        let statusBarHeight = min(
            UIApplication.shared.statusBarFrame.size.width,
            UIApplication.shared.statusBarFrame.size.height
        )
        let topPadding = (navigationBarHeight ?? 0) + statusBarHeight
        
        let offsetWithHeader = scrollOffset
            + postScreenView.headerHeight
        let headerHeight = postScreenView.headerHeight - topPadding
        
        // Pin segmented control
        let scrollViewOffset = min(offsetWithHeader, headerHeight)
        postScreenView.updateScroll(offset: scrollViewOffset)
        
        // Arrange page views contentOffset
        let offsetWithHiddenHeader = -(topPadding)
        self.arrangePagesScrollOffset(
            topOffsetOfCurrentTab: scrollOffset,
            maxTopOffset: offsetWithHiddenHeader
        )
    }
    
    private func arrangePagesScrollOffset(topOffsetOfCurrentTab: CGFloat, maxTopOffset: CGFloat) {
        
        let view = foldableCommentsViewController
        var topOffset = view.contentOffset.y
        
        // Scrolling down
        if topOffset != topOffsetOfCurrentTab && topOffset <= maxTopOffset {
            topOffset = min(topOffsetOfCurrentTab, maxTopOffset)
        }
        
        // Scrolling up
        if topOffset > maxTopOffset && topOffsetOfCurrentTab <= maxTopOffset {
            topOffset = min(topOffsetOfCurrentTab, maxTopOffset)
        }
        
        view.contentOffset = CGPoint(
            x: view.contentOffset.x,
            y: topOffset
        )
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
//            self.postScreenView.updateTableViewData(dataSource: self.tableDataSource)
//            self.postScreenView.postInfo = data.post
            self.postScreenView.bind(with: data.post)
            self.foldableCommentsViewController.showComments(with: data.comments)
            self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
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
    func postScreenView(_ postScreenView: View, didReportNewHeaderHeight height: CGFloat) {
        self.lastKnownHeaderHeight = height
        self.updateContentInset(headerHeight: self.lastKnownHeaderHeight)
    }
}

extension PostScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.lastKnownScrollOffset = scrollView.contentOffset.y
        self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
    }
}
