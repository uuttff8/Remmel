//
//  ProfileSettingsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProfileSettingsAssembly: Assembly {
    
    private let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func makeModule() -> ProfileSettingsViewController {
        let viewModel = ProfileSettingsViewModel(userId: userId)
        let vc = ProfileSettingsViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
