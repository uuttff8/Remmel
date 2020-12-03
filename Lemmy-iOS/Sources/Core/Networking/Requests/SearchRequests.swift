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
    func search(
        parameters: LemmyModel.Search.SearchRequest,
        completion: @escaping (Result<LemmyModel.Search.SearchResponse, LemmyGenericError>) -> Void
    )
    
    func asyncSearch(
        parameters: LemmyModel.Search.SearchRequest
    ) -> AnyPublisher<LemmyModel.Search.SearchResponse, LemmyGenericError>
}

extension RequestsManager: SearchRequestManagerProtocol {
    
    func search(
        parameters: LemmyModel.Search.SearchRequest,
        completion: @escaping (Result<LemmyModel.Search.SearchResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.Site.search.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    func asyncSearch(
        parameters: LemmyModel.Search.SearchRequest
    ) -> AnyPublisher<LemmyModel.Search.SearchResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Site.search.endpoint, parameters: parameters)
    }

}
