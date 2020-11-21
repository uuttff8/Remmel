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
        struct Request {}
        
        struct ViewModel {
            let viewModel: CreatePostViewModel.Data
        }
    }
    
    /// Presents choosing community.
    enum ChooseCommunityFormPresentation {
        struct Request {}

        struct ViewModel {
            let settingDescription: FormFieldDescription
        }
    }
    
    /// Update choosing community.
    enum ChooseCommunityFormUpdate {
        struct Request {
            let community: LemmyModel.CommunityView
        }

        struct ViewModel {
            let settingDescription: FormFieldDescription
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
