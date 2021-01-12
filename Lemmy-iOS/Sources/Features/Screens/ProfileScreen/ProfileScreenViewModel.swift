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
    var loadedProfile: LemmyModel.UserView? { get }
    
    func doProfileFetch()
    func doIdentifyProfile()
    func doProfileLogout()
    func doSubmoduleControllerAppearanceUpdate(request: ProfileScreenDataFlow.SubmoduleAppearanceUpdate.Request)
    func doSubmodulesRegistration(request: ProfileScreenDataFlow.SubmoduleRegistration.Request)
    func doSubmodulesDataFilling(request: ProfileScreenDataFlow.SubmoduleDataFilling.Request)
}

class ProfileScreenViewModel: ProfileScreenViewModelProtocol {
    private var profileId: Int?
    private let profileUsername: String?
    
    weak var viewController: ProfileScreenViewControllerProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    private(set) var loadedProfile: LemmyModel.UserView?

    // Tab index -> Submodule
    private var submodules: [ProfileScreenSubmoduleProtocol] = []
    
    init(
        profileId: Int?,
        profileUsername: String?,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.profileId = profileId
        self.profileUsername = profileUsername
        self.userAccountService = userAccountService
    }
    
    func doProfileFetch() {
        self.viewController?.displayNotBlockingActivityIndicator(viewModel: .init(shouldDismiss: false))
        
        let parameters = LemmyModel.User.GetUserDetailsRequest(userId: profileId,
                                                               username: profileUsername,
                                                               sort: .active,
                                                               page: 1,
                                                               limit: 50,
                                                               communityId: nil,
                                                               savedOnly: false,
                                                               auth: LemmyShareData.shared.jwtToken)
        
        ApiManager.requests.asyncGetUserDetails(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.viewController?.displayNotBlockingActivityIndicator(viewModel: .init(shouldDismiss: true))
                self.loadedProfile = response.user
                self.viewController?.displayProfile(
                    viewModel: .init(state: .result(profile: self.makeHeaderViewData(profile: response.user),
                                                   posts: response.posts,
                                                   comments: response.comments,
                                                   subscribers: response.follows))
                )
            }.store(in: &cancellable)
    }
    
    func doIdentifyProfile() {
        let isCurrent = loadedProfile?.id == userAccountService.currentUser?.id
        ? true
        : false
        
        self.viewController?.displayMoreButtonAlert(
            viewModel: .init(isCurrentProfile: isCurrent)
        )
    }
    
    func doProfileLogout() {
        userAccountService.userLogout()
        NotificationCenter.default.post(name: .didLogin, object: nil)
    }
    
    func doSubmoduleControllerAppearanceUpdate(request: ProfileScreenDataFlow.SubmoduleAppearanceUpdate.Request) {
        self.submodules[request.submoduleIndex].handleControllerAppearance()
    }
    
    func doSubmodulesRegistration(request: ProfileScreenDataFlow.SubmoduleRegistration.Request) {
        request.submodules.forEach { $0.registerSubmodule() }
    }
    
    func doSubmodulesDataFilling(request: ProfileScreenDataFlow.SubmoduleDataFilling.Request) {
        guard let profile = loadedProfile else { return }
        
        self.submodules = request.submodules
        request.submodules.forEach {
            $0.updateFirstData(
                profile: profile,
                posts: request.posts,
                comments: request.comments,
                subscribers: request.subscribers
            )
        }
    }
    
    private func makeHeaderViewData(
        profile: LemmyModel.UserView
    ) -> ProfileScreenHeaderView.ViewData {
        return .init(
            name: profile.name,
            avatarUrl: profile.avatar,
            bannerUrl: profile.banner,
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
                
        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum IdentifyProfile {
        struct Request { }
        
        struct ViewModel {
            let isCurrentProfile: Bool
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
        struct ViewModel {
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
