//
//  ProfileScreenAboutAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProfileScreenAboutAssembly: Assembly {
    
    // Module Input
    var moduleInput: ProfileScreenAboutInputProtocol?
    private let coordinator: WeakBox<ProfileScreenCoordinator>
    
    init(coordinator: WeakBox<ProfileScreenCoordinator>) {
        self.coordinator = coordinator
    }

    func makeModule() -> UIViewController {
        let viewModel = ProfileScreenAboutViewModel()
        let vc = ProfileScreenAboutViewController(viewModel: viewModel)
        viewModel.viewController = vc
        vc.coordinator = coordinator.value
        self.moduleInput = viewModel
        
        return vc
    }
}
