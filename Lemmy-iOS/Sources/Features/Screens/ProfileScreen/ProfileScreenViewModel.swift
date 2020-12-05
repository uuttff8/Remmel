//
//  ProfileScreenModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileScreenViewModelProtocol: AnyObject {
    func doProfileFetch()
    func doSubmoduleControllerAppearanceUpdate(request: ProfileScreenDataFlow.SubmoduleAppearanceUpdate.Request)
    func doSubmodulesRegistration(request: ProfileScreenDataFlow.SubmoduleRegistration.Request)
    func doSubmodulesDataFilling(request: ProfileScreenDataFlow.SubmoduleDataFilling.Request)
}

class ProfileScreenViewModel: ProfileScreenViewModelProtocol {
    private var profileId: Int
    
    weak var viewController: ProfileScreenViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    private var currentProfile: LemmyModel.UserView?

    // Tab index -> Submodule
    private var submodules: [ProfileScreenSubmoduleProtocol] = []
    
    init(profileId: Int) {
        self.profileId = profileId
    }
    
    func doProfileFetch() {
        self.viewController?.displayNotBlockingActivityIndicator(response: .init(shouldDismiss: false))
        
        let parameters = LemmyModel.User.GetUserDetailsRequest(userId: profileId,
                                                               username: nil,
                                                               sort: .active,
                                                               page: 1,
                                                               limit: 50,
                                                               communityId: nil,
                                                               savedOnly: false,
                                                               auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetUserDetails(parameters: parameters)
            .receive(on: RunLoop.main)
            .sink { (error) in
                print(error)
            } receiveValue: { (response) in
                self.viewController?.displayNotBlockingActivityIndicator(response: .init(shouldDismiss: true))
                self.currentProfile = response.user
                self.viewController?.displayProfile(
                    response: .init(state: .result(profile: self.makeHeaderViewData(profile: response.user),
                                                   posts: response.posts,
                                                   comments: response.comments,
                                                   subscribers: response.follows))
                )
            }.store(in: &cancellable)
    }
    
    func doSubmoduleControllerAppearanceUpdate(request: ProfileScreenDataFlow.SubmoduleAppearanceUpdate.Request) {
        self.submodules[request.submoduleIndex].handleControllerAppearance()
    }
    
    func doSubmodulesRegistration(request: ProfileScreenDataFlow.SubmoduleRegistration.Request) {
        request.submodules.forEach { $0.registerSubmodule() }
    }
    
    func doSubmodulesDataFilling(request: ProfileScreenDataFlow.SubmoduleDataFilling.Request) {
        self.submodules = request.submodules
        request.submodules.forEach {
            $0.updateFirstData(posts: request.posts, comments: request.comments, subscribers: request.subscribers)
        }
    }
    
    private func makeHeaderViewData(
        profile: LemmyModel.UserView
    ) -> ProfileScreenHeaderView.ViewData {
        return .init(
            name: profile.name,
            avatarUrl: URL(string: profile.avatar ?? ""),
            bannerUrl: URL(string: profile.banner ?? ""),
            numberOfComments: profile.numberOfComments,
            numberOfPosts: profile.numberOfPosts,
            published: profile.published
        )
    }
}

enum ProfileScreenDataFlow {
    enum Tab: Int, CaseIterable {
        case posts
        case comments
        case about
        
        var title: String {
            switch self {
            case .about: return "About"
            case .comments: return "Comments"
            case .posts: return "Posts"
            }
        }
    }
    
    enum ProfileLoad {
        struct Request { }
        
        struct Response {
            struct Data {
                let profile: LemmyModel.UserView
            }
            
            var result: Swift.Result<Data, Swift.Error>
        }
        
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum SubmoduleDataFilling {
        struct Request {
            let submodules: [ProfileScreenSubmoduleProtocol]
            let posts: [LemmyModel.PostView]
            let comments: [LemmyModel.CommentView]
            let subscribers: [LemmyModel.CommunityFollowerView]
        }
    }
    
    /// Handle submodule controller appearance
    enum SubmoduleAppearanceUpdate {
        struct Request {
            let submoduleIndex: Int
        }
    }
    
    /// Register submodules
    enum SubmoduleRegistration {
        struct Request {
            var submodules: [ProfileScreenSubmoduleProtocol]
        }
    }
    
    enum ShowingActivityIndicator {
        struct Response {
            let shouldDismiss: Bool
        }
    }
    
    enum ViewControllerState {
        case loading
        case result(profile: ProfileScreenHeaderView.ViewData,
                    posts: [LemmyModel.PostView],
                    comments: [LemmyModel.CommentView],
                    subscribers: [LemmyModel.CommunityFollowerView])
    }
}
