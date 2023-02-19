//
//  CommunityScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels
import RMServices
import RMNetworking

class CommunityScreenAssembly: Assembly {
    private let communityId: RMModel.Views.CommunityView.ID?
    private let communityName: String?
    
    init(
        communityId: RMModel.Views.CommunityView.ID?,
        communityName: String?
    ) {
        self.communityId = communityId
        self.communityName = communityName
    }
    
    func makeModule() -> CommunityScreenViewController {
        let userAccountService = UserAccountService()
        
        let viewModel = CommunityScreenViewModel(communityId: communityId,
                                                 communityName: communityName,
                                                 wsClient: ApiManager.chainedWsCLient)
        
        let vc = CommunityScreenViewController(
            viewModel: viewModel,
            followService: CommunityFollowService(
                userAccountService: userAccountService
            ),
            contentScoreService: ContentScoreService(
                userAccountService: userAccountService
            ),
            showMoreService: ShowMoreHandlerServiceImp()
            
        )
        viewModel.viewController = vc
        
        return vc
    }
}
