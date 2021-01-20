//
//  FrontPageViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol FrontPageViewModelProtocol {
    func doNavBarProfileAction()
}

class FrontPageViewModel: FrontPageViewModelProtocol {
    private let userAccountService: UserAccountSerivceProtocol
    
    weak var viewController: FrontPageViewControllerProtocol?
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func doNavBarProfileAction() {
        if let user = self.userAccountService.currentUser {
            self.viewController?.displayProfileScreen(viewModel: .init(user: user))
        } else {
            self.viewController?.displayAutorizationAlert()
        }
    }
}

enum FrontPage {
    
    enum ProfileAction {
        
        struct ViewModel {
            let user: LMModels.Source.UserSafeSettings
        }
    }
}
