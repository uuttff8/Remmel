//
//  ProfileSettingsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMServices

class ProfileSettingsAssembly: Assembly {
    
    func makeModule() -> ProfileSettingsViewController {
        let viewModel = ProfileSettingsViewModel(
            userAccountService: UserAccountService()
        )
        let vc = ProfileSettingsViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
