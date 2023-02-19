//
//  FrontPageAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMServices

class FrontPageAssembly: Assembly {
    
    func makeModule() -> FrontPageViewController {
        let viewModel = FrontPageViewModel(userAccountService: UserAccountService())
        let vc = FrontPageViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
