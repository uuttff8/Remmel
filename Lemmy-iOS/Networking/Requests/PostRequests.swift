//
//  PostRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private protocol LemmyPostRequestManagerProtocol {
    func getPosts<Req: Codable, Res: Codable>(parameters: Req, completion: @escaping ((Result<Res, Error>) -> Void))
}

extension RequestsManager: LemmyPostRequestManagerProtocol {
    func getPosts<Req, Res>(
        parameters: Req,
        completion: @escaping ((Result<Res, Error>) -> Void)
    ) where Req : Codable, Res : Codable {
        
        return requestDecodable(
            path: LemmyEndpoint.Post.getPosts.endpoint,
            parameters: parameters,
            parsingFromRootKey: "data",
            completion: completion
        )
    }
    
    
}
