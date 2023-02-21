//
//  WriteMessageAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMServices

final class WriteMessageAssembly: Assembly {
    
    enum Action {
        case replyToPrivateMessage(recipientId: Int)
        case writeComment(parentComment: RMModels.Source.Comment?, postSource: RMModels.Source.Post)
        case edit(comment: RMModels.Source.Comment)
    }
    
    private let action: Action
    
    init(action: Action) {
        self.action = action
    }
    
    func makeModule() -> WriteMessageViewController {
        let viewModel = WriteMessageViewModel(
            action: action,
            userAccountService: UserAccountService()
        )
        let vc = WriteMessageViewController(viewModel: viewModel)
        viewModel.viewController = vc
        
        return vc
    }
}
