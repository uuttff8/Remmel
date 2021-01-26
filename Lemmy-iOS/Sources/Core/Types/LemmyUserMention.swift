//
//  LemmyMention.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 18.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class LemmyUserMention {
    
    var absoluteUsername: String
    var absoluteId: Int?
    
    init(string: String, id: Int? = nil) {
        if string.hasPrefix("@") {
            var retString = string
            retString.removeFirst()
            
            self.absoluteUsername = retString
            return
        }
        
        if string.hasPrefix("/u/") {
            var retString = string
            retString.removeFirst(3)
            
            self.absoluteUsername = retString
            return
        }
        
        self.absoluteId = id
        self.absoluteUsername = string
    }
    
    init?(url: URL) {
        if let username = parseUsername(passedUrl: url) {
            self.absoluteUsername = username
            return
        }
        
        return nil
    }
}

private func parseUsername(passedUrl: URL) -> String? {
    
    if passedUrl.absoluteString.hasPrefix("@") {
        var retString = passedUrl.absoluteString
        retString.removeFirst()
        
        return retString
    }
    
    if passedUrl.absoluteString.hasPrefix("/u/") {
        var retString = passedUrl.absoluteString
        retString.removeFirst(3)
        
        return retString
    }
    
    if passedUrl.relativePath.contains("/u/") {
        var retString = passedUrl.relativePath
        retString.removeFirst(3)
        
        return retString
    }
    
    return nil
}
