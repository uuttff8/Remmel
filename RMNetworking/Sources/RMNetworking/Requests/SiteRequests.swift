//
//  SiteRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMModels
import RMFoundation

public extension RequestsManager {
    func asyncGetSite(
        parameters: RMModels.Api.Site.GetSite
    ) -> AnyPublisher<RMModels.Api.Site.GetSiteResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Site.getSite.endpoint,
                              parameters: parameters)
    }
}
