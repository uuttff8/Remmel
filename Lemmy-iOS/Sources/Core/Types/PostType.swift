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
        guard let url = postView.post.url else { return PostType.none }
        let str = url.absoluteString
        
        if str.hasSuffix("jpg")    ||
            str.hasSuffix(".jpeg") ||
            str.hasSuffix(".png")  ||
            str.hasSuffix(".gif")  ||
            str.hasSuffix(".webp") ||
            str.hasSuffix(".bmp")  ||
            str.hasSuffix(".wbpm") {
            
            return PostType.image
        }
        
        return PostType.default
    }
}
