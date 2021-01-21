//
//  SettingsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

class SettingsAssembly: Assembly {
    func makeModule() -> SettingsViewController {
        let viewModel = SettingsViewModel()
        let vc = SettingsViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
