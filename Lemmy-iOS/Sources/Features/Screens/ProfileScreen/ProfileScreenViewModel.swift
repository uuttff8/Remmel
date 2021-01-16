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
    var loadedProfile: LMModels.Views.UserViewSafe? { get }
    
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
    
    private(set) var loadedProfile: LMModels.Views.UserViewSafe?
    
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
        
        let parameters = LMModels.Api.User.GetUserDetails(userId: profileId,
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
                
                assert(response.userView != nil || response.userViewDangerous != nil,
                             "it should be either userView or userViewDangerous")
                
                if let userView = response.userView {
                    self.loadedProfile = userView
                } else if let userView = response.userViewDangerous {
                    self.loadedProfile = userView
                }
                
                guard let loadedProfile = self.loadedProfile else { return }
                          
                // if blocked user then show nothing
                if self.userIsBlocked(userId: loadedProfile.user.id) {
                    self.viewController?.displayProfile(viewModel: .init(state: .blockedUser))
                    return
                }
                
                self.viewController?.displayProfile(
                    viewModel: .init(state: .result(profile: self.makeHeaderViewData(profile: loadedProfile),
                                                    posts: response.posts,
                                                    comments: response.comments,
                                                    subscribers: response.follows))
                )
            }.store(in: &cancellable)
    }
    
    func doIdentifyProfile() {
        let isCurrent = loadedProfile?.user.id == userAccountService.currentUser?.id
            ? true
            : false
        
        let userId = loadedProfile.require().user.id
        
        let isBlocked = self.userIsBlocked(userId: userId)
        
        self.viewController?.displayMoreButtonAlert(
            viewModel: .init(isCurrentProfile: isCurrent, isBlocked: isBlocked, userId: userId)
        )
    }
    
    func doProfileLogout() {
        userAccountService.userLogout()
        NotificationCenter.default.post(name: .didLogin, object: nil)
    }
    
    func doSubmoduleControllerAppearanceUpdate(request: ProfileScreenDataFlow.SubmoduleAppearanceUpdate.Request) {
        guard let submodules = self.submodules[safe: request.submoduleIndex] else {
            Logger.commonLog.error("Submodule is not found")
            return
        }
        submodules.handleControllerAppearance()
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
    
    private func userIsBlocked(userId: Int) -> Bool {
        if LemmyShareData.shared.blockedUsersId.contains(userId) {
            return true
        }
        
        return false
    }
    
    private func makeHeaderViewData(
        profile: LMModels.Views.UserViewSafe
    ) -> ProfileScreenHeaderView.ViewData {
        return .init(
            name: profile.user.name,
            avatarUrl: profile.user.avatar,
            bannerUrl: profile.user.banner,
            numberOfComments: profile.counts.commentCount,
            numberOfPosts: profile.counts.postCount,
            published: profile.user.published.toLocalTime()
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
            let isBlocked: Bool
            let userId: Int
        }
    }
    
    enum BlockedUser {
        struct ViewModel { }
    }
    
    enum SubmoduleDataFilling {
        struct Request {
            let submodules: [ProfileScreenSubmoduleProtocol]
            let posts: [LMModels.Views.PostView]
            let comments: [LMModels.Views.CommentView]
            let subscribers: [LMModels.Views.CommunityFollowerView]
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
                    posts: [LMModels.Views.PostView],
                    comments: [LMModels.Views.CommentView],
                    subscribers: [LMModels.Views.CommunityFollowerView])
        case blockedUser
    }
}
