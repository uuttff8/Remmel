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
    func loadImage(urlString: URL?, imageSize: CGSize, blur: Bool = false) {
        
        if let url = urlString {
            self.isHidden = false
            
            var processors: [ImageProcessing] = [ImageProcessors.Resize(size: imageSize)]
            
            if blur {
                processors.append(ImageProcessors.GaussianBlur())
            }
            
            let request = ImageRequest(
                url: url,
                processors: processors
            )
            
            let options = ImageLoadingOptions(
                transition: ImageLoadingOptions.Transition.fadeIn(
                    duration: 0.15
                )
            )
            
            Nuke.loadImage(
                with: request,
                options: options,
                into: self
            )
        } else {
            self.isHidden = true
        }
    }
    
    // load image or hide the view if it is not
    func loadImage(urlString: URL?, completion: ImageTask.Completion? = nil) {
        
        if let url = urlString {

            self.isHidden = false
            
            let request = ImageRequest(url: url)
            
            let options = ImageLoadingOptions(
                transition: ImageLoadingOptions.Transition.fadeIn(
                    duration: 0.15
                )
            )
            
            Nuke.loadImage(
                with: request,
                options: options,
                into: self,
                completion: completion
            )
        } else {
            self.isHidden = true
        }
    }

}
