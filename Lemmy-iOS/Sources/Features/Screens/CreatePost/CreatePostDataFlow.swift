//
//  CreatePostDataFlow.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum CreatePost {
    // Present CreatePost
    enum CreatePostLoad {
        struct Request { }
        
        struct ViewModel { }
    }
    
    enum RemoteCreatePost {
        struct Request {
            let communityId: Int
            let title: String
            let body: String?
            let url: String?
            let nsfw: Bool
        }
        
        struct ViewModel {
            let post: LemmyModel.PostView
        }
    }
    
    enum CreatePostError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
    
    enum BlockingWaitingIndicatorUpdate {
        struct Response {
            let shouldDismiss: Bool
        }

        struct ViewModel {
            let shouldDismiss: Bool
        }
    }
    
    struct FormFieldDescription {
        let fields: [FormField]
        let currentField: FormField?

        struct FormField: UniqueIdentifiable {
            let uniqueIdentifier: UniqueIdentifierType
            let title: String
        }
    }
}
