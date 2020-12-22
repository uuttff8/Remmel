//
//  String+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension String {
    func removeNewLines() -> String {
        return self.filter({ !("\n".contains($0)) })
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var encodeUrl: String {
        self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl: String {
        self.removingPercentEncoding!
    }
}
