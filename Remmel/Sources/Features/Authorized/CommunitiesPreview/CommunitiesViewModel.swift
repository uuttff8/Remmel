//
//  CommunitiesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMModels
import RMServices
import RMNetworking
import RMFoundation

protocol CommunitiesPreviewViewModelProtocol {
    func doReceiveMessages()
    func doLoadCommunities(request: CommunitiesPreview.CommunitiesLoad.Request)
}

class CommunitiesPreviewViewModel: CommunitiesPreviewViewModelProtocol {
    
    weak var viewContoller: CommunitiesPreviewViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(wsClient: WSClientProtocol) {
        self.wsClient = wsClient
    }
    
    func doReceiveMessages() {
        self.wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
            guard let self = self else {
                return
            }
            
            switch operation {
            case RMUserOperation.ListCommunities.rawValue:
                guard let comms = self.wsClient?.decodeWsType(
                        RMModel.Api.Community.ListCommunitiesResponse.self,
                        data: data
                ) else { return }
                
                DispatchQueue.main.async {
                    self.fetchCommunities(with: comms)
                }
            default: break
            }
        })
    }
    
    func doLoadCommunities(request: CommunitiesPreview.CommunitiesLoad.Request) {
        let parameters = RMModel.Api.Community.ListCommunities(
            type: .all,
            sort: RMModel.Others.SortType.topAll,
            page: 1,
            limit: 100,
            auth: LemmyShareData.shared.jwtToken
        )
        
        self.wsClient?.send(RMUserOperation.ListCommunities, parameters: parameters)
    }
    
    private func fetchCommunities(with response: RMModel.Api.Community.ListCommunitiesResponse) {
        let sortedCommunities = response.communities
            .sorted { $0.subscribed && !$1.subscribed }
        
        self.viewContoller?.displayCommunities(
            viewModel: .init(state: .result(sortedCommunities))
        )
    }
}

enum CommunitiesPreview {
    
    enum CommunitiesLoad {
        struct Request {}
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case loading
        case result([RMModel.Views.CommunityView])
    }
}
