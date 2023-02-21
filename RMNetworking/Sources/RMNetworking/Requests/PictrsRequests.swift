//
//  PictrsRequests.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 25.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation
import RMModels

public extension RequestsManager {
    func uploadPictrs(
        image: UIImage,
        filename: String,
        completion: @escaping (Result<Pictrs.PictrsResponse, LemmyGenericError>) -> Void
    ) {

        return _uploadImage(
            path: HttpEndpoint.Pictrs.image.endpoint,
            image: image,
            filename: filename,
            completion: completion
        )
    }
}
