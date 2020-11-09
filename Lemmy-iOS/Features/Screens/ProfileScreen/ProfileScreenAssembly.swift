//
//  ProfileScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileInfoScreenAssembly: Assembly {
    private let profileUsername: String
    
    init(profileUsername: String) {
        self.profileUsername = profileUsername
    }
    
    func makeModule() -> UIViewController {
        let viewModel = ProfileScreenViewModel(profileUsername: self.profileUsername)
        let viewController = ProfileScreenViewController(viewModel: viewModel)
        
        viewModel.viewController = viewController
        
        return viewController
    }
}
