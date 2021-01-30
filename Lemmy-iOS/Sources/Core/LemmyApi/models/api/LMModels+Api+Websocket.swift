//
//  LMModels+Api+Websocket.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 30.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

extension LMModels.Api {
    
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
        
        struct CommunityJoin {
            let communityId: Int
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
            }
        }
        
        struct CommunityJoinResponse {
            let joined: Bool
        }
        
        struct ModJoin {
            let communityId: Int
            
            enum CodingKeys: String, CodingKey {
                case communityId = "community_id"
            }
        }
        
        struct ModJoinResponse {
            let joined: Bool
        }
        
        struct PostJoin {
            let postId: Int
            
            enum CodingKeys: String, CodingKey {
                case postId = "post_id"
            }
        }
        
        struct PostJoinResponse {
            let joined: Bool
        }
    }
    
}
