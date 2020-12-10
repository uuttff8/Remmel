//
//  ProfileScreenCommentsAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenCommentsAssembly: Assembly {
    
    // Module Input
    var moduleInput: ProfileScreenCommentsInputProtocol?
    private let coordinator: WeakBox<ProfileScreenCoordinator>
    
    init(coordinator: WeakBox<ProfileScreenCoordinator>) {
        self.coordinator = coordinator
    }

    func makeModule() -> UIViewController {
        let viewModel = ProfileScreenCommentsViewModel(
            contentScoreService: ContentScoreService(
                voteService: UpvoteDownvoteRequestService(userAccountService: UserAccountService())
            )
        )
        let vc = ProfileScreenCommentsViewController(viewModel: viewModel, showMoreHandler: ShowMoreHandlerService())
        vc.coordinator = coordinator.value
        viewModel.viewController = vc
        self.moduleInput = viewModel
        
        return vc
    }
}
