//
//  FrontPageViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol FrontPageViewModelProtocol {
    func receiveMessages()
    func doNavBarProfileAction()
}

class FrontPageViewModel: FrontPageViewModelProtocol {
    private let userAccountService: UserAccountSerivceProtocol
    
    private let wsEvents = ApiManager.chainedWsCLient
    
    weak var viewController: FrontPageViewControllerProtocol?
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func receiveMessages() {
        
        let commJoin = LMModels.Api.Websocket.CommunityJoin(communityId: 0)

        wsEvents?.send(
            WSEndpoint.Community.communityJoin.endpoint,
            parameters: commJoin
        )
        
        guard let jwtToken = LemmyShareData.shared.jwtToken else {
            Logger.commonLog.info("No token at UserJoin")
            return
        }
        
        let userJoin = LMModels.Api.Websocket.UserJoin(auth: jwtToken)
        wsEvents?.send(WSEndpoint.User.userJoin.endpoint, parameters: userJoin)
    }
    
    func doNavBarProfileAction() {
        if let user = self.userAccountService.currentUser {
            self.viewController?.displayProfileScreen(viewModel: .init(user: user))
        } else {
            self.viewController?.displayAutorizationAlert()
        }
    }
}

enum FrontPage {
    
    enum ProfileAction {
        
        struct ViewModel {
            let user: LMModels.Source.UserSafeSettings
        }
    }
}
