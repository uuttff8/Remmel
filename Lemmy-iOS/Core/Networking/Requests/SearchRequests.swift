//
//  SearchRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

private protocol SearchRequestManagerProtocol {
    func search(
        parameters: LemmyApiStructs.Search.SearchRequest,
        completion: @escaping (Result<LemmyApiStructs.Search.SearchResponse, LemmyGenericError>) -> Void
    )
}

extension RequestsManager: SearchRequestManagerProtocol {
    func search(
        parameters: LemmyApiStructs.Search.SearchRequest,
        completion: @escaping (Result<LemmyApiStructs.Search.SearchResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: LemmyEndpoint.Site.search.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
}
