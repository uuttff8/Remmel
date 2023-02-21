//
//  FrontPageViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 14.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMServices
import RMModels
import RMNetworking
import RMFoundation

protocol FrontPageViewModelProtocol {
    func receiveMessages()
    func doNavBarProfileAction()
}

class FrontPageViewModel: FrontPageViewModelProtocol {
    private let userAccountService: UserAccountServiceProtocol
    
    private let wsEvents = ApiManager.chainedWsCLient
    
    weak var viewController: FrontPageViewControllerProtocol?
    
    init(
        userAccountService: UserAccountServiceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func receiveMessages() {
        
        let commJoin = RMModels.Api.Websocket.CommunityJoin(communityId: 0)

        wsEvents.send(
            WSEndpoint.Community.communityJoin.endpoint,
            parameters: commJoin
        )
        
        guard let jwtToken = LemmyShareData.shared.jwtToken else {
            debugPrint("No token at UserJoin")
            return
        }
        
        let userJoin = RMModels.Api.Websocket.UserJoin(auth: jwtToken)
        wsEvents.send(WSEndpoint.User.userJoin.endpoint, parameters: userJoin)
    }
    
    func doNavBarProfileAction() {
        if let user = self.userAccountService.currentUserInfo?.localUserView {
            self.viewController?.displayProfileScreen(viewModel: .init(user: user))
        } else {
            self.viewController?.displayAutorizationAlert()
        }
    }
}

enum FrontPage {
    
    enum ProfileAction {
        
        struct ViewModel {
            let user: RMModels.Views.LocalUserSettingsView
        }
    }
}
