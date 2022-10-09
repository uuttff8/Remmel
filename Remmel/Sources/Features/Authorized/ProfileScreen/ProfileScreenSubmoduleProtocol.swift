//
//  ProfileScreenSubmoduleProtocol.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol ProfileScreenSubmoduleProtocol: AnyObject {
    func handleControllerAppearance()
    func updatePostsData(
        profile: ProfileScreenViewModel.ProfileData,
        posts: [LMModels.Views.PostView]
    )
    
    func updateCommentsData(
        profile: ProfileScreenViewModel.ProfileData,
        comments: [LMModels.Views.CommentView]
    )
    
    func updateFollowersData(
        profile: ProfileScreenViewModel.ProfileData,
        subscribers: [LMModels.Views.CommunityFollowerView]
    )

    func registerSubmodule()
}

extension ProfileScreenSubmoduleProtocol {
    func updatePostsData(
        profile: ProfileScreenViewModel.ProfileData,
        posts: [LMModels.Views.PostView]
    ) {}
    
    func updateCommentsData(
        profile: ProfileScreenViewModel.ProfileData,
        comments: [LMModels.Views.CommentView]
    ) {}
    
    func updateFollowersData(
        profile: ProfileScreenViewModel.ProfileData,
        subscribers: [LMModels.Views.CommunityFollowerView]
    ) {}
}
