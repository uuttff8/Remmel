//
//  ProfileScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileInfoScreenAssembly: Assembly {
    private let profileId: Int
    
    init(profileId: Int) {
        self.profileId = profileId
    }
    
    func makeModule() -> ProfileScreenViewController {
        let viewModel = ProfileScreenViewModel(
            profileId: self.profileId,
            userAccountService: UserAccountService()
        )
        let viewController = ProfileScreenViewController(viewModel: viewModel)
        
        viewModel.viewController = viewController
        
        return viewController
    }
}
