//
//  SiteRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

extension RequestsManager {
    func asyncGetSite(
        parameters: LMModels.Api.Site.GetSite
    ) -> AnyPublisher<LMModels.Api.Site.GetSiteResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Site.getSite.endpoint,
                              parameters: parameters)
    }
    
    func asyncListCategories(
        parameters: LMModels.Api.Site.ListCategories
    ) -> AnyPublisher<LMModels.Api.Site.ListCategoriesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Site.listCategories.endpoint, parameters: parameters)
    }
}
