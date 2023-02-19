//
//  ChooseCommunityAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

final class ChooseCommunityAssembly: Assembly {
    typealias ViewController = ChooseCommunityViewController
    
    var onCommunitySelected: ((RMModel.Views.CommunityView) -> Void)?
    
    func makeModule() -> ChooseCommunityViewController {
        let viewModel = ChooseCommunityViewModel()
        let vc = ChooseCommunityViewController(viewModel: viewModel)
        
        vc.onCommunitySelected = onCommunitySelected
        
        viewModel.viewController = vc
        
        return vc
    }
}
