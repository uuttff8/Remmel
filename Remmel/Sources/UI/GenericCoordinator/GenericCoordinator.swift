//
//  GenericCoordinator.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

class GenericCoordinator<T: UIViewController>: BaseCoordinator, SFSafariViewControllerDelegate {
    
    // MARK: - Properties
    
    var rootViewController: T! // implement it
    var router: RouterProtocol?
    
    let userAccountService: UserAccountSerivceProtocol
    
    // MARK: - Init
    
    init(router: RouterProtocol?, userAccountService: UserAccountSerivceProtocol = UserAccountService()) {
        self.router = router
        self.userAccountService = userAccountService
        super.init()
        
        navigationController = router?.navigationController
        router?.viewController = self.rootViewController
    }
    
    override func start() {
        fatalError("Override this")
    }
        
    // MARK: - SFSafariViewControllerDelegate

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        rootViewController.dismiss(animated: true)
    }
}
