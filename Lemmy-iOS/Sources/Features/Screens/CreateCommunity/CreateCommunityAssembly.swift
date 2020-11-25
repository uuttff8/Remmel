//
//  CreateCommunityAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityAssembly: Assembly {
    typealias ViewController = CreateCommunityViewController
    
    func makeModule() -> CreateCommunityViewController {
        let viewModel = CreateCommunityViewModel()
        let vc = CreateCommunityViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
