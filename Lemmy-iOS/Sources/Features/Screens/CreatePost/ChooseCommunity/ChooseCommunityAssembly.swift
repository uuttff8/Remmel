//
//  ChooseCommunityAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ChooseCommunityAssembly: Assembly {
    typealias ViewController = ChooseCommunityViewController
    
    var onCommunitySelected: ((LemmyModel.CommunityView) -> Void)?
    
    func makeModule() -> ChooseCommunityViewController {
        let viewModel = ChooseCommunityViewModel()
        let vc = ChooseCommunityViewController(viewModel: viewModel)
        
        onCommunitySelected = vc.onCommunitySelected
        
        viewModel.viewController = vc
        
        return vc
    }
}
