//
//  CommunitiesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CommunitiesPreviewViewModelProtocol {
    func doLoadCommunities(request: CommunitiesPreview.CommunitiesLoad.Request)
}

class CommunitiesPreviewViewModel: CommunitiesPreviewViewModelProtocol {
    
    weak var viewContoller: CommunitiesPreviewViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    func doLoadCommunities(request: CommunitiesPreview.CommunitiesLoad.Request) {
        let parameters = LMModels.Api.Community.ListCommunities(
            sort: LMModels.Others.SortType.topAll,
            page: 1,
            limit: 100,
            auth: LemmyShareData.shared.jwtToken
        )
        
        ApiManager.requests.asyncListCommunities(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                
                self.viewContoller?.displayCommunities(
                    viewModel: .init(state: .result(response.communities))
                )
                
            }.store(in: &cancellable)
        
    }
}

class CommunitiesPreview {
    
    enum CommunitiesLoad {
        struct Request {}
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case loading
        case result([LMModels.Views.CommunityView])
    }
}
