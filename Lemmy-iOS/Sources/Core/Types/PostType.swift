//
//  PostType.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

enum PostType {
    case image
    case video
    case `default`
    case none
    
    static func getPostType(from postView: LMModels.Views.PostView) -> PostType {
        guard let url = postView.post.url,
              !url.isEmpty
        else { return PostType.none }
        
        if url.hasSuffix("jpg")
            || url.hasSuffix(".jpeg")
            || url.hasSuffix(".png")
            || url.hasSuffix(".gif")
            || url.hasSuffix(".webp")
            || url.hasSuffix(".bmp")
            || url.hasSuffix(".wbpm") {
            
            return PostType.image
        }
        
        return PostType.default
    }
}
