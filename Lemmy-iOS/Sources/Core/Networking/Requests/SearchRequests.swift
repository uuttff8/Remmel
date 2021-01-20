//
//  SearchRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

extension RequestsManager {
        
    func asyncSearch(
        parameters: LMModels.Api.Site.Search
    ) -> AnyPublisher<LMModels.Api.Site.SearchResponse, LemmyGenericError> {
        
        asyncRequestDecodable(path: WSEndpoint.Site.search.endpoint, parameters: parameters)
    }

}
