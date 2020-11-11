//
//  ProfileScreenCommentsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 11.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileScreenCommentsViewModelProtocol {
    // TODO do pagination
    func doProfilePostsFetch()
}

class ProfileScreenCommentsViewModel: ProfileScreenPostsViewModelProtocol {
    weak var viewController: ProfileScreenCommentsViewControllerProtocol?
    
    var cancellable = Set<AnyCancellable>()
    
    func doProfilePostsFetch() { }
}

extension ProfileScreenCommentsViewModel: ProfileScreenCommentsInputProtocol {
    func updateFirstData(posts: [LemmyModel.PostView], comments: [LemmyModel.CommentView]) {
        self.viewController?.displayProfileComments(
            viewModel: .init(state: .result(data: .init(comments: comments)))
        )
    }
    
    func registerSubmodule() { }
    
    func handleControllerAppearance() { }
}

class ProfileScreenComments {
    enum CommentsLoad {
        struct Response {
            let comments: [LemmyModel.CommentView]
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    // MARK: States
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenCommentsViewController.View.ViewData)
    }
}

