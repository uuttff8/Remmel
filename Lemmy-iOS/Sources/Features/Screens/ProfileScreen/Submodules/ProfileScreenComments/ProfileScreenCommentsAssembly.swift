//
//  ProfileScreenCommentsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenCommentsAssembly: Assembly {
    
    // Module Input
    var moduleInput: ProfileScreenCommentsInputProtocol?

    func makeModule() -> UIViewController {
        let viewModel = ProfileScreenCommentsViewModel()
        let vc = ProfileScreenCommentsViewController(viewModel: viewModel)
        viewModel.viewController = vc
        self.moduleInput = viewModel
        
        return vc
    }
}
