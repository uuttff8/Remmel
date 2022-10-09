//
//  CreateCommunityDataFlow.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum CreateCommunity {
    
    enum CreateCommunityFormLoad {
        struct Request { }
        
        struct ViewModel { }
    }
    
    enum RemoteCreateCommunity {
        struct Request {
            let name: String
            let displayName: String
            let sidebar: String?
            let icon: String?
            let banner: String?
            let nsfwOption: Bool
        }
        
        struct ViewModel { }
    }
    
    enum SuccessCreateCommunity {
        struct Request { }
        
        struct ViewModel {
            let community: LMModels.Views.CommunityView
        }
    }
    
    enum ErrorCreateCommunity {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
    
}
