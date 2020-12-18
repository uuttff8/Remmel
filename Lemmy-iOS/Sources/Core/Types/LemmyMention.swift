//
//  LemmyMention.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 18.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class LemmyMention {
    
    let absoluteUsername: String
    
    init?(string: String) {
        if string.hasPrefix("@") {
            var retString = string
            retString.removeFirst()
            
            self.absoluteUsername = retString
            return
        }
        
        return nil
    }
    
    init?(url: URL) {
        if url.absoluteString.hasPrefix("/u/") {
            var retString = url.absoluteString
            retString.removeFirst(3)
            
            self.absoluteUsername = retString
            return
        }
        
        return nil
    }
}
