//
//  CreatePostModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenModel {
    
    // MARK: - Properties
    var communitiesLoaded: ((Array<LemmyApiStructs.CommunityView>) -> Void)?
    
    var communitiesData: Array<LemmyApiStructs.CommunityView> = []
    var filteredCommunitiesData: Array<LemmyApiStructs.CommunityView> = []
    
    // MARK: - Initializer
    init() { }
    
    // MARK: - Api Request
    func loadCommunities() {
        let parameters = LemmyApiStructs.Community.ListCommunitiesRequest(sort: LemmySortType.topAll,
                                                                          limit: 100,
                                                                          page: nil,
                                                                          auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.listCommunities(parameters: parameters)
        { (res: Result<LemmyApiStructs.Community.ListCommunitiesResponse, Error>) in
            
            switch res {
            case let .success(data):
                self.communitiesData = data.communities
                self.communitiesLoaded?(data.communities)
            case let .failure(why):
                print(why)
                break
            }
        }
    }
    
    func searchCommunities(query: String) {
    }
}
