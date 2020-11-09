//
//  ProfileScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileScreenViewControllerProtocol: AnyObject {
    func displayProfile(response: ProfileScreenDataFlow.ProfileLoad.ViewModel)
    func displayNotBlockingActivityIndicator(response: ProfileScreenDataFlow.ShowingActivityIndicator.Response)
}

class ProfileScreenViewController: UIViewController {
    
    private let viewModel: ProfileScreenViewModelProtocol
    
    private lazy var headerView = self.view as! ProfileScreenViewController.View
    
    init(viewModel: ProfileScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = ProfileScreenViewController.View(frame: UIScreen.main.bounds,
                                                    tabsTitles: ["11"])
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        viewModel.doProfileFetch()
    }
}

extension ProfileScreenViewController: ProfileScreenViewControllerProtocol {
    func displayProfile(response: ProfileScreenDataFlow.ProfileLoad.ViewModel) {
        guard case let .result(data) = response.state else { return }
        headerView.configure(viewData: data)
    }
    
    func displayNotBlockingActivityIndicator(response: ProfileScreenDataFlow.ShowingActivityIndicator.Response) {
        response.shouldDismiss ? self.headerView.hideLoading() : self.headerView.showLoading()
        
    }
}
