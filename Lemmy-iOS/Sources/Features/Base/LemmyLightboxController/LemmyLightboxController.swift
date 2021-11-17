//
//  LemmyLightboxController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.11.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import Lightbox

class LemmyLightboxController: LightboxController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        let imageD = UIImage(named: "arrow-down-solid")?.withTintColor(.white)
        let downloadImageView = UIImageView(image: imageD)
        view.addSubview(downloadImageView)
        downloadImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(20)
            make.bottom.equalTo(footerView.snp.top).inset(-10)
            make.trailing.equalToSuperview().inset(16)
        }
        
        downloadImageView.addTap {
            guard let photo = self.images[safe: self.currentPage]?.image else {
                return
            }
            self.writeToPhotoAlbum(image: photo)
        }
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveResult(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func saveResult(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // we got back an error!
            let alert = UIAlertController(
                title: nil,
                message: "Seems like app is not allowed to save photos",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Fix in settings", style: .default, handler: { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
