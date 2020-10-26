//
//  LemmyApiStructs+Post.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LemmyApiStructs {
    enum Post {
        
        // MARK: - GetPosts -
        struct GetPostsRequest: Codable, Equatable {
            let type_: LemmyFeedType
            let sort: LemmySortType
            let page: Int?
            let limit: Int?
            let communityId: Int?
            let communityName: String?
            let auth: String?
            
            enum CodingKeys: String, CodingKey {
                case type_ = "type_"
                case sort, page, limit
                case communityId = "community_id"
                case communityName = "community_name"
                case auth
            }
        }
        
        struct GetPostsResponse: Codable, Equatable {
            let posts: Array<PostView>
        }
        
        // MARK: - GetPost -
        struct GetPostRequest: Codable, Equatable {
            let id: Int
            let auth: String?
        }
        
        struct GetPostResponse: Codable, Equatable {
            let post: PostView
            let comments: Array<CommentView>
            let community: CommunityView
            let moderators: Array<CommunityModeratorView>
        }
        
        // MARK: - CreatePost -
        struct CreatePostRequest: Codable, Equatable {
            let name: String
            let url: String?
            let body: String?
            let nsfw: Bool
            let communityId: Int
            let auth: String
            
            enum CodingKeys: String, CodingKey {
                case name, url, body, nsfw
                case communityId = "community_id"
                case auth
            }
        }
        
        struct CreatePostResponse: Codable, Equatable {
            let post: PostView
        }
    }
}
