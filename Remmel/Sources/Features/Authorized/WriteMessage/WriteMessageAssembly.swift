//
//  WriteMessageAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

final class WriteMessageAssembly: Assembly {
    
    enum Action {
        case replyToPrivateMessage(recipientId: Int)
        case writeComment(parentComment: LMModels.Source.Comment?, postSource: LMModels.Source.Post)
        case edit(comment: LMModels.Source.Comment)
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
