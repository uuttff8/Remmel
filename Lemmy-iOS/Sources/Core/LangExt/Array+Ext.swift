//
//  Array+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func getElement(by id: Element.ID) -> Element? {
        if let index = self.firstIndex(where: { $0.id == id }) {
            return self[index]
        }
        
        return nil
    }
    
    mutating func updateElement(_ element: Element) {
        if let index = self.firstIndex(where: { $0.id == element.id }) {
            self[index] = element
        }
    }
}
