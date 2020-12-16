//
//  CommunitiesAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CommunitiesPreviewAssembly: Assembly {
    
    func makeModule() -> CommunitiesPreviewViewController {
        let viewModel = CommunitiesPreviewViewModel()
        let vc = CommunitiesPreviewViewController(viewModel: viewModel)
        viewModel.viewContoller = vc
        
        return vc
    }
}
