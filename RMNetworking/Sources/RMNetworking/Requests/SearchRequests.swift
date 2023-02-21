//
//  SearchRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine
import RMFoundation
import RMModels

public extension RequestsManager {
        
    func asyncSearch(
        parameters: RMModels.Api.Site.Search
    ) -> AnyPublisher<RMModels.Api.Site.SearchResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Site.search.endpoint, parameters: parameters)
    }

}
