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
    func updateFirstData(
        profile: LMModels.Views.UserViewSafe,
        posts: [LMModels.Views.PostView],
        comments: [LMModels.Views.CommentView],
        subscribers: [LMModels.Views.CommunityFollowerView]
    )
    func registerSubmodule()
}
