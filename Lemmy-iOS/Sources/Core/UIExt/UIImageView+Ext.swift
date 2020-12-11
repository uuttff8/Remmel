//
//  UIImageView+Ext.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    
    // load image or hide the view if it is not
    func loadImage(urlString: String?) {
        
        if let url = URL(string: urlString ?? "") {
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(
                    transition: ImageLoadingOptions.Transition.fadeIn(
                        duration: 0.15
                    )
                ),
                into: self
            )
            
        } else {
            self.isHidden = true
        }
    }
    
}
