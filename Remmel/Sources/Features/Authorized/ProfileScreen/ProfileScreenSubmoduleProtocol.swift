//
//  ProfileScreenSubmoduleProtocol.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import RMModels

protocol ProfileScreenSubmoduleProtocol: AnyObject {
    func handleControllerAppearance()
    func updatePostsData(
        profile: ProfileScreenViewModel.ProfileData,
        posts: [RMModel.Views.PostView]
    )
    
    func updateCommentsData(
        profile: ProfileScreenViewModel.ProfileData,
        comments: [RMModel.Views.CommentView]
    )
    
    func updateFollowersData(
        profile: ProfileScreenViewModel.ProfileData,
        subscribers: [RMModel.Views.CommunityFollowerView]
    )

    func registerSubmodule()
}

extension ProfileScreenSubmoduleProtocol {
    func updatePostsData(
        profile: ProfileScreenViewModel.ProfileData,
        posts: [RMModel.Views.PostView]
    ) {}
    
    func updateCommentsData(
        profile: ProfileScreenViewModel.ProfileData,
        comments: [RMModel.Views.CommentView]
    ) {}
    
    func updateFollowersData(
        profile: ProfileScreenViewModel.ProfileData,
        subscribers: [RMModel.Views.CommunityFollowerView]
    ) {}
}
