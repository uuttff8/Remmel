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
            print("Not Logined")
            return
        }
        
        let params = LemmyModel.Community.CreateCommunityRequest(name: request.name,
                                                                 title: request.displayName,
                                                                 description: request.sidebar,
                                                                 icon: request.icon,
                                                                 banner: request.banner,
                                                                 categoryId: request.category?.id ?? 1,
                                                                 nsfw: request.nsfwOption,
                                                                 auth: jwtToken)
        ApiManager.requests.asyncCreateCommunity(parameters: params)
            .receive(on: RunLoop.main)
            .sink { (completion) in
                
                switch completion {
                case .failure(let error):
                    self.viewController?.displayErrorCreatingCommunity(
                        viewModel: .init(error: error.description)
                    )
                case .finished:
                    print(completion)
                }
                
            } receiveValue: { (response) in
                self.viewController?.displaySuccessCreatingCommunity(
                    viewModel: .init(community: response.community)
                )
            }.store(in: &cancellable)

    }
    
    func doCreateCommunityFormLoad(request: CreateCommunity.CreateCommunityFormLoad.Request) {
        self.viewController?.displayCreateCommunityForm(viewModel: .init())
    }
}
