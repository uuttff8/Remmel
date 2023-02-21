//
//  File.swift
//  
//
//  Created by uuttff8 on 20/02/2023.
//

import Foundation

extension UserDefaults {
    func resetDefaults() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            self.removeObject(forKey: key)
        }
    }
}
