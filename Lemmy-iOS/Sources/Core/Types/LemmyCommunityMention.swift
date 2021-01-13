//
//  LemmyCommunityMention.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 13.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

class LemmyCommunityMention {
    
    let absoluteName: String
    
    init?(name: String) {
        if name.hasPrefix("/c/") {
            var retString = name
            retString.removeFirst(3)
                        
            self.absoluteName = retString
            return
        }
        
        return nil
    }
    
    init?(url: URL) {
        
        if url.absoluteString.hasPrefix("/c/") {
            var retString = url.absoluteString
            retString.removeFirst(3)
                        
            self.absoluteName = retString
            return
        }
        
        return nil
    }
}
