//
//  RMModels+Api+Websocket.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 30.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension RMModels.Api {
    
    enum Websocket {
        
        struct UserJoin: Codable {
            let auth: String
        }
        
        struct UserJoinResponse: Codable {
            let joined: Bool
        }
        
        /**
         * The main / frontpage community is `community_id: 0`.
         */
        
        struct CommunityJoin: Codable {
            let communityId: Int
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
            }
        }
        
        struct CommunityJoinResponse: Codable {
            let joined: Bool
        }
        
        struct ModJoin: Codable {
            let communityId: Int
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
            }
        }
        
        struct ModJoinResponse: Codable {
            let joined: Bool
        }
        
        struct PostJoin: Codable {
            let postId: Int
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
            }
        }
        
        struct PostJoinResponse: Codable {
            let joined: Bool
        }
    }
    
}
