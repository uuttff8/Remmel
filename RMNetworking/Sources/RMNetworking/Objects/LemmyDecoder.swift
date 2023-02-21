//
//  LemmyDecoder.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMFoundation

class LemmyDecoder {
    
    struct ApiResponse: Codable {
        let op: String
    }
    
    let decoder = LemmyJSONDecoder()
        
    func decode(
        data: Data,
        completion: ((Result<String, LemmyGenericError>) -> Void)? = nil
    ) {
        do {
            let apiResponse = try self.decoder.decode(ApiResponse.self, from: data)
            
            completion?(.success(apiResponse.op))
        } catch {
            do {
                let errorResponse = try self.decoder.decode(ApiErrorResponse.self, from: data)
                completion?(.failure(.string(errorResponse.error)))
            } catch {
                completion?(.failure(LemmyGenericError.string("Can't decode api response: \n \(error)")))
            }
        }
    }
}
