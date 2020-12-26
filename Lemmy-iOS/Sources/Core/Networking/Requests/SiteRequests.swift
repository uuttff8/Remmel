//
//  SiteRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

private protocol SiteRequestManagerProtocol {
    func asyncGetSite(
        parameters: LemmyModel.Site.GetSiteRequest
    ) -> AnyPublisher<LemmyModel.Site.GetSiteResponse, LemmyGenericError>
    
    func asyncListCategories(
        parameters: LemmyModel.Site.ListCategoriesRequest
    ) -> AnyPublisher<LemmyModel.Site.ListCategoriesResponse, LemmyGenericError>
}

extension RequestsManager: SiteRequestManagerProtocol {    
    func asyncGetSite(
        parameters: LemmyModel.Site.GetSiteRequest
    ) -> AnyPublisher<LemmyModel.Site.GetSiteResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Site.getSite.endpoint,
                              parameters: parameters)
    }
    
    func asyncListCategories(
        parameters: LemmyModel.Site.ListCategoriesRequest
    ) -> AnyPublisher<LemmyModel.Site.ListCategoriesResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Site.listCategories.endpoint, parameters: parameters)
    }
}
