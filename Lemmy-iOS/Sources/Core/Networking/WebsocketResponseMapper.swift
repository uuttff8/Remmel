//
//  WebsocketResponseMapper.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 24.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

private let mapper: [String: Codable.Type] = [
    "GetPosts": LemmyModel.Post.GetPostsResponse.self,
    "CreatePostLike": LemmyModel.Post.CreatePostLikeResponse.self,
    "Error": ApiErrorResponse.self
]

private let decoder = LemmyJSONDecoder()

func WSResponseMapper(response: String) -> Codable.Type? {
    let op = response.asDictionary!["op"] as! String
    
    if let mapped = mapper[op] {
        return mapped
    }
    
    return nil
}
