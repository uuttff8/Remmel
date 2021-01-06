//
//  WriteMessageAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

final class WriteMessageAssembly: Assembly {
    
    private let recipientId: Int
    
    init(recipientId: Int) {
        self.recipientId = recipientId
    }
    
    func makeModule() -> WriteMessageViewController {
        let viewModel = WriteMessageViewModel(
            recipientId: recipientId,
            userAccountService: UserAccountService()
        )
        let vc = WriteMessageViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
