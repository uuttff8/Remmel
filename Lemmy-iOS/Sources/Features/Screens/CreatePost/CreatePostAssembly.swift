//
//  CreatePostAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CreatePostAssembly: Assembly {
    typealias ViewController = CreatePostScreenViewController
    
    func makeModule() -> CreatePostScreenViewController {
        let viewModel = CreatePostViewModel()
        let vc = CreatePostScreenViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
