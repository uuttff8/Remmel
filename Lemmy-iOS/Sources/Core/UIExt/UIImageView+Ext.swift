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
    func loadImage(urlString: String?, blur: Bool = false) {
        
        if let url = URL(string: urlString ?? "") {
            
            var processors: [ImageProcessing] = [ImageProcessors.Resize(size: self.bounds.size)]
            
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
    
    private func blurImage(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale

        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(10.0, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage

        var cgImage: CGImage?

        if let asd = outputImage {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }

        if let cgImageA = cgImage {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }

        return nil
    }
    
}
