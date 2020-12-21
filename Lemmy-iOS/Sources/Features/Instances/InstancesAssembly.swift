//
//  InstancesAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class InstancesAssembly: Assembly {
    func makeModule() -> InstancesViewController {
        let provider = InstancesProvider(
            instancesPersistenceService: InstancePersistenceService()
        )
        let viewModel = InstancesViewModel(
            provider: provider
        )
        
        let vc = InstancesViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
