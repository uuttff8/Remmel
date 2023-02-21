//
//  EditPostAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMServices
import RMNetworking

final class EditPostAssembly: Assembly {
        
    private let postSource: RMModels.Source.Post
    
    init(postSource: RMModels.Source.Post) {
        self.postSource = postSource
    }
    
    func makeModule() -> EditPostViewController {
        let viewModel = EditPostViewModel(postSource: postSource,
                                          userAccountService: UserAccountService(),
                                          wsClient: ApiManager.chainedWsCLient)
        let vc = EditPostViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
