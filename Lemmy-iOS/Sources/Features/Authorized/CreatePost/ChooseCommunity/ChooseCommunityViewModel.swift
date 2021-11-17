//
//  ChooseCommunityViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ChooseCommunityViewModelProtocol: AnyObject {
    func doCommunitiesLoad(request: ChooseCommunity.CommunitiesLoad.Request)
    func doSearchCommunities(request: ChooseCommunity.SearchCommunities.Request)
}

class ChooseCommunityViewModel: ChooseCommunityViewModelProtocol {
    weak var viewController: ChooseCommunityViewControllerProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    func doCommunitiesLoad(request: ChooseCommunity.CommunitiesLoad.Request) {
        let parameters = LMModels.Api.Community.ListCommunities(type: .all,
                                                                sort: LMModels.Others.SortType.topAll,
                                                                page: nil,
                                                                limit: 100,
                                                                auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncListCommunities(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                
                self.viewController?.displayCommunities(
                    viewModel: .init(
                        state: .result(response.communities)
                    )
                )
                
            }.store(in: &cancellables)
    }
    
    func doSearchCommunities(request: ChooseCommunity.SearchCommunities.Request) {
        let params = LMModels.Api.Site.Search(query: request.query,
                                              type: .communities,
                                              communityId: nil,
                                              communityName: nil,
                                              creatorId: nil,
                                              sort: .topAll,
                                              listingType: nil,
                                              page: 1,
                                              limit: 100,
                                              auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncSearch(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.viewController?.displaySearchResults(
                    viewModel: .init(
                        state: .result(response.communities)
                    )
                )
            }.store(in: &cancellables)
    }
    
}

enum ChooseCommunity {
    
    enum CommunitiesLoad {
        struct Request { }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum SearchCommunities {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case loading
        case result([LMModels.Views.CommunityView])
    }
}
