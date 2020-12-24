//
//  SearchRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

private protocol SearchRequestManagerProtocol {    
    func asyncSearch(
        parameters: LemmyModel.Search.SearchRequest
    ) -> AnyPublisher<LemmyModel.Search.SearchResponse, LemmyGenericError>
}

extension RequestsManager: SearchRequestManagerProtocol {
        
    func asyncSearch(
        parameters: LemmyModel.Search.SearchRequest
    ) -> AnyPublisher<LemmyModel.Search.SearchResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Site.search.endpoint, parameters: parameters)
    }

}
