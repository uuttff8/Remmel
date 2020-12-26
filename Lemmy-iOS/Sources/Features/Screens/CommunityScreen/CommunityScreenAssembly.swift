//
//  CommunityScreenAssembly.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenAssembly: Assembly {
    private let communityId: LemmyModel.CommunityView.Id
    private let communityInfo: LemmyModel.CommunityView?
    
    init(
        communityId: LemmyModel.CommunityView.Id,
        communityInfo: LemmyModel.CommunityView?
    ) {
        self.communityId = communityId
        self.communityInfo = communityInfo
    }
    
    func makeModule() -> CommunityScreenViewController {
        let userAccountService = UserAccountService()
        
        let viewModel = CommunityScreenViewModel(communityId: communityId,
                                                 communityInfo: communityInfo)
        
        let vc = CommunityScreenViewController(
            viewModel: viewModel,
            followService: CommunityFollowService(
                userAccountService: userAccountService
            ),
            contentScoreService: ContentScoreService(
                voteService: UpvoteDownvoteRequestService(
                    userAccountService: userAccountService
                )
            ),
            showMoreService: ShowMoreHandlerService()
            
        )
        viewModel.viewController = vc
        
        return vc
    }
}
