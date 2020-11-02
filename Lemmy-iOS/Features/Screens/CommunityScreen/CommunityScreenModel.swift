//
//  CommunityScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

class CommunityScreenModel {
    let communitySubject: CurrentValueSubject<LemmyApiStructs.CommunityView?, Never> = CurrentValueSubject(nil)
    
    func loadCommunity(id: Int) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { return }
        
        let parameters = LemmyApiStructs.Community.GetCommunityRequest(id: id, name: nil, auth: jwtToken)
        
        ApiManager.requests.getCommunity(parameters: parameters) { [self] (res) in
            switch res {
            case let .success(response):
                communitySubject.send(response.community)
            case let .failure(error):
                print(error.description)
            }
        }
    }
}
