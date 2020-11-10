//
//  ProfileScreenPostsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenPostsAssembly: Assembly {
    
    // Module Input
    var moduleInput: ProfileScreenPostsInputProtocol?

    func makeModule() -> UIViewController {
        let viewModel = ProfileScreenPostsSubViewModel()
        let vc = ProfileScreenPostsSubViewController(viewModel: viewModel)
        viewModel.viewController = vc
        self.moduleInput = viewModel
        
        return vc
    }
}
