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
    func updateFirstData(posts: [LemmyModel.PostView],
                         comments: [LemmyModel.CommentView],
                         subscribers: [LemmyModel.CommunityFollowerView])
    func registerSubmodule()
}
