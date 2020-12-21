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
    func getSite(
        parameters: LemmyModel.Site.GetSiteRequest,
        completion: @escaping (Result<LemmyModel.Site.GetSiteResponse, LemmyGenericError>) -> Void
    )
    func listCategoties(
        parameters: LemmyModel.Site.ListCategoriesRequest,
        completion: @escaping (Result<LemmyModel.Site.ListCategoriesResponse, LemmyGenericError>) -> Void
    )
    
    func asyncGetSite(
        parameters: LemmyModel.Site.GetSiteRequest
    ) -> AnyPublisher<LemmyModel.Site.GetSiteResponse, LemmyGenericError>
}

extension RequestsManager: SiteRequestManagerProtocol {
    func getSite<Req, Res>(
        parameters: Req,
        completion: @escaping (Result<Res, LemmyGenericError>) -> Void
    ) where Req: Codable, Res: Codable {

        return requestDecodable(
            path: WSEndpoint.Site.getSite.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }

    func listCategoties(
        parameters: LemmyModel.Site.ListCategoriesRequest,
        completion: @escaping (Result<LemmyModel.Site.ListCategoriesResponse, LemmyGenericError>) -> Void
    ) {

        return requestDecodable(
            path: WSEndpoint.Site.listCategories.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    func asyncGetSite(
        parameters: LemmyModel.Site.GetSiteRequest
    ) -> AnyPublisher<LemmyModel.Site.GetSiteResponse, LemmyGenericError> {
        asyncRequestDecodable(path: WSEndpoint.Site.getSite.endpoint,
                              parameters: parameters)
    }
}
