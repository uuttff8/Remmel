//
//  CreatePostAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

final class CreatePostAssembly: Assembly {
    
    private let predefinedCommunity: RMModels.Views.CommunityView?
    
    init(predefinedCommunity: RMModels.Views.CommunityView? = nil) {
        self.predefinedCommunity = predefinedCommunity
    }
    
    func makeModule() -> CreatePostScreenViewController {
        let viewModel = CreatePostViewModel()
        let vc = CreatePostScreenViewController(
            viewModel: viewModel,
            predefinedCommunity: self.predefinedCommunity
        )
        viewModel.viewController = vc
        
        return vc
    }
}
