//
//  ChooseCommunityViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ChooseCommunityViewModelProtocol: AnyObject {
    func doCommunitiesLoad(request: ChooseCommunity.CommunitiesLoad.Request)
    func doSearchCommunities(request: ChooseCommunity.SearchCommunities.Request)
}

class ChooseCommunityViewModel: ChooseCommunityViewModelProtocol {
    weak var viewController: ChooseCommunityViewControllerProtocol?
    
    func doCommunitiesLoad(request: ChooseCommunity.CommunitiesLoad.Request) {
        let parameters = LemmyModel.Community.ListCommunitiesRequest(sort: LemmySortType.topAll,
                                                                     limit: 100,
                                                                     page: nil,
                                                                     auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.listCommunities(
            parameters: parameters
        ) { (res: Result<LemmyModel.Community.ListCommunitiesResponse, LemmyGenericError>) in
            
            switch res {
            case let .success(data):
                DispatchQueue.main.async {
                    self.viewController?.displayCommunities(
                        viewModel: .init(
                            state: .result(data.communities)
                        )
                    )
                }
            case let .failure(why):
                print(why)
            }
        }
    }
    
    func doSearchCommunities(request: ChooseCommunity.SearchCommunities.Request) {
        let params = LemmyModel.Search.SearchRequest(query: request.query,
                                                     type: .communities,
                                                     sort: .all,
                                                     page: 1,
                                                     limit: 100,
                                                     communityId: nil,
                                                     communityName: nil,
                                                     auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.search(
            parameters: params
        ) { (res: Result<LemmyModel.Search.SearchResponse, LemmyGenericError>) in
            
            switch res {
            case let .success(data):
                DispatchQueue.main.async {
                    self.viewController?.displaySearchResults(
                        viewModel: .init(
                            state: .result(data.communities)
                        )
                    )
                }
            case let .failure(why):
                print(why)
            }
        }
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
        case result([LemmyModel.CommunityView])
    }
}
