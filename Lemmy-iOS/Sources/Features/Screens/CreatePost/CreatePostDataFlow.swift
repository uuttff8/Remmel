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
    
    /// Presents download video quality setting screen.
    enum ChooseCommunityFormPresentation {
        struct Request {}

        struct ViewModel {
            let settingDescription: FormFieldDescription
        }
    }
    
    /// Presents download video quality setting screen.
    enum ChooseCommunityFormUpdate {
        struct Request {}

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
