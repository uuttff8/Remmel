//
//  ProfileScreenAboutViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 12.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileScreenAboutViewModelProtocol {
    // TODO do pagination
    func doProfileAboutFetch()
}

class ProfileScreenAboutViewModel: ProfileScreenAboutViewModelProtocol {
    weak var viewController: ProfileScreenAboutViewControllerProtocol?
    
    private var loadedProfile: ProfileScreenViewModel.ProfileData?
    
    var cancellable = Set<AnyCancellable>()
    
    func doProfileAboutFetch() { }
}

extension ProfileScreenAboutViewModel: ProfileScreenAboutInputProtocol {
    func updateFirstData(
        profile: ProfileScreenViewModel.ProfileData,
        posts: [LMModels.Views.PostView],
        comments: [LMModels.Views.CommentView],
        subscribers: [LMModels.Views.CommunityFollowerView]
    ) {
        self.loadedProfile = profile
        self.viewController?.displayProfileSubscribers(
            viewModel: .init(state: .result(data: .init(subscribers: subscribers)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

class ProfileScreenAbout {
    enum SubscribersLoad {
        struct Response {
            let subscribers: [LMModels.Views.CommunityFollowerView]
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    // MARK: States
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenAboutViewController.View.ViewData)
    }
}
