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
    "CreatePostLike": LemmyModel.Post.CreatePostLikeResponse.self
]

private let decoder = LemmyJSONDecoder()

func WSResponseMapper<T: Codable>(op: String) -> T.Type? {
    if let mapped = mapper[op] as? T.Type {
        return mapped
    }
    
    return nil
}
