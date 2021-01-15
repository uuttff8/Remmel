//
//  Aggregates.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 15.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels {
    enum Aggregates {
        struct UserAggregates: Codable {
          let id: Int
          let user_id: Int
          let post_count: Int
          let post_score: Int
          let comment_count: Int
          let comment_score: Int
        }

        struct SiteAggregates: Codable {
          let id: Int
          let site_id: Int
          let users: Int
          let posts: Int
          let comments: Int
          let communities: Int
        }

        struct PostAggregates: Codable {
          let id: Int
          let post_id: Int
          let comments: Int
          let score: Int
          let upvotes: Int
          let downvotes: Int
          let newest_comment_time: Int
        }

        struct CommunityAggregates: Codable {
          let id: Int
          let community_id: Int
          let subscribers: Int
          let posts: Int
          let comments: Int
        }

        struct CommentAggregates: Codable {
          let id: Int
          let comment_id: Int
          let score: Int
          let upvotes: Int
          let downvotes: Int
        }

    }
}
