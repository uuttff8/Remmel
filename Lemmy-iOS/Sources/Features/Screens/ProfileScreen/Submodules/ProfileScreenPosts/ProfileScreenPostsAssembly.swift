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
    private let coordinator: WeakBox<ProfileScreenCoordinator>
    
    init(coordinator: WeakBox<ProfileScreenCoordinator>) {
        self.coordinator = coordinator
    }

    func makeModule() -> ProfileScreenPostsViewController {
        let viewModel = ProfileScreenPostsViewModel()
        let vc = ProfileScreenPostsViewController(viewModel: viewModel)
        vc.coordinator = coordinator.value
        viewModel.viewController = vc
        self.moduleInput = viewModel
        
        return vc
    }
}
