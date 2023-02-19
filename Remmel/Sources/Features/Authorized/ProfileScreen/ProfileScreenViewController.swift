//
//  ProfileScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Pageboy
import RMFoundation

protocol ProfileScreenScrollablePageViewProtocol: AnyObject {
    var scrollViewDelegate: UIScrollViewDelegate? { get set }
    var contentInsets: UIEdgeInsets { get set }
    var contentOffset: CGPoint { get set }
    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior { get set }
}

protocol ProfileScreenViewControllerProtocol: AnyObject {
    func displayProfile(viewModel: ProfileScreenDataFlow.ProfileLoad.ViewModel)
    func displayNotBlockingActivityIndicator(viewModel: ProfileScreenDataFlow.ShowingActivityIndicator.ViewModel)
    func displayMoreButtonAlert(viewModel: ProfileScreenDataFlow.IdentifyProfile.ViewModel)
}

class ProfileScreenViewController: UIViewController {
    private static let topBarAlphaStatusBarThreshold = 0.85
    
    weak var coordinator: ProfileScreenCoordinator?
    
    private let viewModel: ProfileScreenViewModelProtocol

    private var availableTabs: [ProfileScreenDataFlow.Tab] = [.posts, .comments]
    private lazy var pageViewController = PageboyViewController()
    
    // Due to lazy initializing we should know actual values to update inset/offset of new scrollview
    private var lastKnownScrollOffset: CGFloat = 0
    private var lastKnownHeaderHeight: CGFloat = 0
    
    // Element is nil when view controller was not initialized yet
    private var submodulesControllers: [UIViewController?]
    private var submoduleInputs: [ProfileScreenSubmoduleProtocol?] = []
    
    private lazy var profileScreenView = view as? ProfileScreenViewController.View
    lazy var styledNavigationController = navigationController as? StyledNavigationController
    
    private lazy var showMoreBarButton = UIBarButtonItem(
        image: Config.Image.ellipsis,
        style: .done,
        target: self,
        action: #selector(moreBarButtonTapped(_:))
    )
    
    private var storedViewModel: ProfileScreenHeaderView.ViewData?
    
    init(viewModel: ProfileScreenViewModel) {
        self.viewModel = viewModel
        self.submodulesControllers = Array(repeating: nil, count: self.availableTabs.count)
        self.submoduleInputs = Array(repeating: nil, count: self.availableTabs.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: VC Lifecycle
    override func loadView() {
        let statusBarHeight = UIApplication.shared.lemmyStatusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0

        let appearance = ProfileScreenViewController.View.Appearance(
            headerTopOffset: statusBarHeight + navigationBarHeight
        )

        let view = ProfileScreenViewController.View(
            frame: UIScreen.main.bounds,
            pageControllerView: pageViewController.view,
            scrollDelegate: self,
            tabsTitles: self.availableTabs.map { $0.title },
            appearance: appearance
        )
        view.delegate = self
        
        self.view = view
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.doReceiveMessages()
        viewModel.doProfileFetch()
        
        addChild(self.pageViewController)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        profileScreenView?.updateCurrentPageIndex(ProfileScreenDataFlow.Tab.posts.rawValue)
        
        styledNavigationController?.removeBackButtonTitleForTopController()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        styledNavigationController?.insertBackButtonTitleForTopController()
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.view.performBlockIfAppearanceChanged(from: previousTraitCollection) {
            // Update status bar style.
            self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
        }
    }
    
    // MARK: NavBar Actions
    
    @objc private func moreBarButtonTapped(_ action: UIBarButtonItem) {
        self.viewModel.doIdentifyProfile()
    }
    
    private func updateTopBar(alpha: CGFloat) {
        self.view.performBlockUsingViewTraitCollection {
            self.styledNavigationController?.changeBackgroundColor(
                StyledNavigationController.Appearance.backgroundColor.withAlphaComponent(alpha),
                sender: self
            )

//            let transitionColor = ColorTransitionHelper.makeTransitionColor(
//                from: .darkText,
//                to: .label,
//                transitionProgress: alpha
//            )
//            self.styledNavigationController?.changeTintColor(transitionColor, sender: self)
            self.styledNavigationController?.changeTextColor(
                StyledNavigationController.Appearance.tintColor.withAlphaComponent(alpha),
                sender: self
            )

//            let statusBarStyle: UIStatusBarStyle = {
//                if alpha > CGFloat(ProfileScreenViewController.topBarAlphaStatusBarThreshold) {
//                    return self.view.isDarkInterfaceStyle ? .lightContent : .dark
//                } else {
//                    return .lightContent
//                }
//            }()
//
//            self.styledNavigationController?.changeStatusBarStyle(statusBarStyle, sender: self)
        }
    }
    
    private func loadSubmodulesIfNeeded(at index: Int) {
        
        guard submodulesControllers[index] == nil else {
            return
        }

        guard let tab = availableTabs[safe: index] else {
            return
        }
        
        guard let coordinator = coordinator else {
            debugPrint("Coordinator not found")
            return
        }
        
        var moduleInput: ProfileScreenSubmoduleProtocol?
        let controller: UIViewController
        
        switch tab {
        case .posts:
            let assembly = ProfileScreenPostsAssembly(coordinator: WeakBox(coordinator))
            controller = assembly.makeModule()
            moduleInput = assembly.moduleInput
        case .comments:
            let assembly = ProfileScreenCommentsAssembly(coordinator: WeakBox(coordinator))
            controller = assembly.makeModule()
            moduleInput = assembly.moduleInput
        }
        
        submodulesControllers[index] = controller

        if let submodule = moduleInput {
            viewModel.doSubmodulesRegistration(request: .init(submodules: [index: submodule]))
            submoduleInputs[index] = submodule
            
            guard let profile = self.viewModel.loadedProfile else {
                return
            }

            viewModel.doSubmodulesDataFilling(
                request: .init(
                    submodules: [index: submodule],
                    posts: profile.userDetails.posts,
                    comments: profile.userDetails.comments
                )
            )
        }
    }
    
    // Update content inset (to make header visible)
    private func updateContentInset(headerHeight: CGFloat) {
        // Update contentInset for each page
        for viewController in self.submodulesControllers {

            let view = viewController?.view as? ProfileScreenScrollablePageViewProtocol

            if let view = view {
                view.contentInsets = UIEdgeInsets(
                    top: headerHeight,
                    left: view.contentInsets.left,
                    bottom: view.contentInsets.bottom,
                    right: view.contentInsets.right
                )
                view.scrollViewDelegate = self
            }

            viewController?.view.setNeedsLayout()
            viewController?.view.layoutIfNeeded()

            view?.contentInsetAdjustmentBehavior = .never
        }
    }

    // Update content offset (to update appearance and offset on each tab)
    private func updateContentOffset(scrollOffset: CGFloat) {
        guard let profileScreenView = profileScreenView else {
            return
        }

        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height
        let statusBarHeight = min(
            UIApplication.shared.lemmyStatusBarFrame.size.width,
            UIApplication.shared.lemmyStatusBarFrame.size.height
        )
        let topPadding = (navigationBarHeight ?? 0) + statusBarHeight

        let offsetWithHeader = scrollOffset
            + profileScreenView.headerHeight
            + profileScreenView.appearance.segmentedControlHeight
        let headerHeight = profileScreenView.headerHeight - topPadding

        let scrollingProgress = max(0, min(1, offsetWithHeader / headerHeight))
        updateTopBar(alpha: scrollingProgress)

        // Pin segmented control
        let scrollViewOffset = min(offsetWithHeader, headerHeight)
        profileScreenView.updateScroll(offset: scrollViewOffset)

        // Arrange page views contentOffset
        let offsetWithHiddenHeader = -(topPadding + profileScreenView.appearance.segmentedControlHeight)
        arrangePagesScrollOffset(
            topOffsetOfCurrentTab: scrollOffset,
            maxTopOffset: offsetWithHiddenHeader
        )
    }
    
    private func arrangePagesScrollOffset(topOffsetOfCurrentTab: CGFloat, maxTopOffset: CGFloat) {
        for viewController in self.submodulesControllers {
            guard let view = viewController?.view as? ProfileScreenScrollablePageViewProtocol else {
                continue
            }

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
    }

}

extension ProfileScreenViewController: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        availableTabs.count
    }
    
    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        loadSubmodulesIfNeeded(at: index)
        updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
        updateContentInset(headerHeight: self.lastKnownHeaderHeight)
        return submodulesControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: ProfileScreenDataFlow.Tab.posts.rawValue)
    }
        
    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: PageboyViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        profileScreenView?.updateCurrentPageIndex(index)
        viewModel.doSubmoduleControllerAppearanceUpdate(request: .init(submoduleIndex: index))
    }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        willScrollToPageAt index: PageboyViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) { }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollTo position: CGPoint,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) { }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didReloadWith currentViewController: UIViewController,
        currentPageIndex: PageboyViewController.PageIndex
    ) { }
}

extension ProfileScreenViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lastKnownScrollOffset = scrollView.contentOffset.y
        updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
    }
}

extension ProfileScreenViewController: ProfileScreenViewControllerProtocol {
    func displayProfile(viewModel: ProfileScreenDataFlow.ProfileLoad.ViewModel) {
        navigationItem.rightBarButtonItem = showMoreBarButton
        
        switch viewModel.state {
        case let .result(headerData, posts, comments):
            self.title = "@" + headerData.name
            storedViewModel = headerData
            profileScreenView?.configure(viewData: headerData)
            
            submoduleInputs.compactMap({ $0 }).enumerated().forEach {
                key, module in

                self.viewModel.doSubmodulesDataFilling(
                    request: .init(
                        submodules: [key: module],
                        posts: posts,
                        comments: comments
                    )
                )

            }
            
        case .blockedUser:
            UIAlertController.createOkAlert(message: "alert-blocked-user".localized)
            
            submoduleInputs.compactMap({ $0 }).enumerated().forEach {
                key, module in

                self.viewModel.doSubmodulesDataFilling(
                    request: .init(
                        submodules: [key: module],
                        posts: [],
                        comments: []
                    )
                )

            }
        case .loading:
            fatalError("PIZDEC")
        }

    }
    
    func displayNotBlockingActivityIndicator( viewModel: ProfileScreenDataFlow.ShowingActivityIndicator.ViewModel) {
         viewModel.shouldDismiss
            ? profileScreenView?.hideActivityIndicatorView()
            : profileScreenView?.showActivityIndicatorView()
    }
    
    func displayMoreButtonAlert(viewModel: ProfileScreenDataFlow.IdentifyProfile.ViewModel) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = showMoreBarButton
                
        if viewModel.isCurrentProfile {
            let logoutAction = UIAlertAction(title: "alert-logout".localized, style: .destructive) {
                [weak self] _ in

                self?.viewModel.doProfileLogout()
                self?.styledNavigationController?.popViewController(animated: true)
            }
            
            let editProfileAction = UIAlertAction(title: "profile-edit".localized, style: .default) {
                [weak self] _ in

                self?.coordinator?.goToProfileSettings()
            }
            
            alert.addAction(editProfileAction)
            alert.addAction(logoutAction)
            
        } else {
            
            let sendMessageAction = UIAlertAction(title: "alert-send-message".localized, style: .default) {
                [weak self] _ in

                self?.coordinator?.goToWriteMessage(recipientId: viewModel.userId)
            }
            
            let blockAction: UIAlertAction
            if viewModel.isBlocked {
                blockAction = UIAlertAction(title: "alert-unblock".localized, style: .destructive) {
                    _ in

                    let userId = viewModel.userId
                    if let index = LemmyShareData.shared.blockedUsersId.firstIndex(where: { $0 == userId }) {
                        LemmyShareData.shared.blockedUsersId.remove(at: index)
                    }
                    
                    UIAlertController.createOkAlert(message: "alert-unblock-done".localized)
                }

            } else {
                blockAction = UIAlertAction(title: "alert-block".localized, style: .destructive) {
                    _ in

                    let userId = viewModel.userId
                    LemmyShareData.shared.blockedUsersId.append(userId)
                    UIAlertController.createOkAlert(message: "alert-block-done".localized)
                }

            }
            
            alert.addAction(blockAction)
            alert.addAction(sendMessageAction)
        }
        
        let shareAction = UIAlertAction.createShareAction(
            title: "alert-share".localized,
            on: self,
            toEndpoint: viewModel.actorId.absoluteString
        )
        
        let chooseInstanceAction = UIAlertAction(title: "alert-choose-instance".localized, style: .default) {
            [weak self] _ in

            self?.coordinator?.goToInstances()
        }
        
        alert.addAction(chooseInstanceAction)
        alert.addAction(shareAction)
        alert.addAction(UIAlertAction.cancelAction)
        
        self.present(alert, animated: true)
    }
}

extension ProfileScreenViewController: ProfileScreenViewDelegate {
    func numberOfPages(in courseInfoView: ProfileScreenViewController.View) -> Int {
        submodulesControllers.count
    }
    
    func profileView(_ profileView: View, didRequestScrollToPage index: Int) {
        pageViewController.scrollToPage(.at(index: index), animated: true)
    }

    func profileView(_ profileView: View, didReportNewHeaderHeight height: CGFloat) {
        lastKnownHeaderHeight = height
        updateContentInset(headerHeight: self.lastKnownHeaderHeight)
    }
}

extension ProfileScreenViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        StyledNavigationController.NavigationBarAppearanceState(
            shadowViewAlpha: 0.0,
            backgroundColor: StyledNavigationController.Appearance.backgroundColor.withAlphaComponent(0.0),
            statusBarColor: StyledNavigationController.Appearance.statusBarColor.withAlphaComponent(0.0),
            textColor: StyledNavigationController.Appearance.tintColor.withAlphaComponent(0.0),
            tintColor: .label,
            statusBarStyle: .default
        )
    }
}
