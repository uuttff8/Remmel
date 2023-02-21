//
//  RMModels+Api+Websocket.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 30.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

public extension RMModels.Api {
    
    enum Websocket {
        
        public struct UserJoin: Codable {
            public let auth: String
            
            public init(auth: String) {
                self.auth = auth
            }
        }
        
        public struct UserJoinResponse: Codable {
            public let joined: Bool
        }
        
        /**
         * The main / frontpage community is `community_id: 0`.
         */
        
        public struct CommunityJoin: Codable {
            public let communityId: Int
            
            public init(communityId: Int) {
                self.communityId = communityId
            }
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
            }
        }
        
        public struct CommunityJoinResponse: Codable {
            public let joined: Bool
        }
        
        public struct ModJoin: Codable {
            public let communityId: Int
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
            }
        }
        
        public struct ModJoinResponse: Codable {
            public let joined: Bool
        }
        
        public struct PostJoin: Codable {
            public let postId: Int
            
            public init(postId: Int) {
                self.postId = postId
            }
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
            }
        }
        
        public struct PostJoinResponse: Codable {
            public let joined: Bool
        }
    }
    
}
