//
//  InboxNotificationsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Pageboy

protocol InboxNotificationsViewControllerProtocol: AnyObject {
    
}

final class InboxNotificationsViewController: UIViewController {
    
    weak var coordinator: InboxNotificationsCoordinator?
    private let viewModel: InboxNotificationsViewModel
    
    private lazy var pageViewController = PageboyViewController()

    lazy var inboxView = self.view as? InboxNotificationsView
    lazy var styledNavigationController = self.navigationController as? StyledNavigationController
    
    // Element is nil when view controller was not initialized yet
    private var submodulesControllers: [UIViewController?] = []
    
    init(
        viewModel: InboxNotificationsViewModel
    ) {
        self.viewModel = viewModel
        self.submodulesControllers = Array(repeating: nil, count: self.viewModel.submodules.count)

        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = InboxNotificationsView(
            frame: UIScreen.main.bounds,
            pageControllerView: self.pageViewController.view,
            tabsTitles: self.viewModel.availableTabs.map { $0.title }
        )
        view.delegate = self
        self.view = view
    }
    
    // MARK: - Private API
    private func loadSubmoduleIfNeeded(at index: Int) {
        guard self.submodulesControllers[index] == nil else {
            return
        }

        guard let tab = self.viewModel.availableTabs[safe: index] else {
            return
        }

//        let moduleInput: CourseInfoSubmoduleProtocol?
        let controller: UIViewController
        switch tab {
        case .mentions:
//            let assembly = UIViewController()
            controller = UIViewController()
            controller.view.backgroundColor = .yellow
//            moduleInput = assembly.moduleInput
        case .messages:
//            let assembly = UIViewController()
//                output: self.interactor as? CourseInfoTabSyllabusOutputProtocol
//            )
            controller = UIViewController()
            controller.view.backgroundColor = .blue
//            moduleInput = assembly.moduleInput
        case .replies:
//            let assembly = UIViewController()
            controller = UIViewController()
            controller.view.backgroundColor = .red
//            moduleInput = assembly.moduleInput
        }

        self.submodulesControllers[index] = controller

//        if let submodule = moduleInput {
//            self.interactor.doSubmodulesRegistration(request: .init(submodules: [index: submodule]))
//        }
    }
}

// MARK: - InboxNotificationsViewController: PageboyViewControllerDataSource, PageboyViewControllerDelegate -
extension InboxNotificationsViewController: PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        self.viewModel.submodules.count
    }

    func viewController(
        for pageboyViewController: PageboyViewController,
        at index: PageboyViewController.PageIndex
    ) -> UIViewController? {
        self.loadSubmoduleIfNeeded(at: index)
//        self.updateContentOffset(scrollOffset: self.lastKnownScrollOffset)
//        self.updateContentInset(headerHeight: self.lastKnownHeaderHeight)
        return self.submodulesControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        .at(index: self.viewModel.initialTabIndex)
    }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: PageboyViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        self.inboxView?.updateCurrentPageIndex(index)
        self.viewModel.doSubmoduleControllerAppearanceUpdate(request: .init(submoduleIndex: index))
    }

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        willScrollToPageAt index: PageboyViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {}

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollTo position: CGPoint,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {}

    func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didReloadWith currentViewController: UIViewController,
        currentPageIndex: PageboyViewController.PageIndex
    ) {}
}

extension InboxNotificationsViewController: InboxNotificationsViewDelegate {
    func inboxNotifView(_ view: InboxNotificationsView, didReportNewHeaderHeight height: CGFloat) {
        
    }
    
    func inboxNotifView(_ view: InboxNotificationsView, didRequestScrollToPage index: Int) {
        self.pageViewController.scrollToPage(.at(index: index), animated: true)
    }
    
    func numberOfPages(in profileView: InboxNotificationsView) -> Int {
        self.viewModel.availableTabs.count
    }
}

extension InboxNotificationsViewController: InboxNotificationsViewControllerProtocol {
    
}
