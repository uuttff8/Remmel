//
//  CreateCommunityModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CreateCommunityViewModelProtocol: AnyObject {
    func doCreateCommunityFormLoad(request: CreateCommunity.CreateCommunityFormLoad.Request)
    func doRemoteCreateCommunity(request: CreateCommunity.RemoteCreateCommunity.Request)
}

class CreateCommunityViewModel: CreateCommunityViewModelProtocol {
    
    weak var viewController: CreateCommunityViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    func doRemoteCreateCommunity(request: CreateCommunity.RemoteCreateCommunity.Request) {
        guard let jwtToken = LemmyShareData.shared.jwtToken
        else {
            Logger.common.emergency("Create Community should be unreachable when user is not authed")
            return
        }
        
        let params = LMModels.Api.Community.CreateCommunity(
            name: request.name,
            title: request.displayName,
            description: request.sidebar,
            icon: request.icon,
            banner: request.banner,
            nsfw: request.nsfwOption,
            postingRestrictedToMods: nil,
            auth: jwtToken
        )
        ApiManager.requests.asyncCreateCommunity(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.common.info(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayErrorCreatingCommunity(
                        viewModel: .init(error: error.description)
                    )
                }
                
            } receiveValue: { response in
                self.viewController?.displaySuccessCreatingCommunity(
                    viewModel: .init(community: response.communityView)
                )
            }.store(in: &cancellable)

    }
    
    func doCreateCommunityFormLoad(request: CreateCommunity.CreateCommunityFormLoad.Request) {
        self.viewController?.displayCreateCommunityForm(viewModel: .init())
    }
}
