//
//  Config.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

struct Config {
    
}

extension Config {
    struct Color {
        static var separator: UIColor {
            if UIScreen.isDarkMode {
                return UIColor.separator
            } else {
                return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            }
        }
        
        static var highlightCell: UIColor {
            if UIScreen.isDarkMode {
                return UIColor.systemGray6
            } else {
                return UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
            }
        }
    }
    
}

extension Config {
    struct Image {

    }
}
