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
}

class ProfileScreenViewModel: ProfileScreenViewModelProtocol {
    private var profileUsername: String
    
    weak var viewController: ProfileScreenViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
    private var currentProfile: LemmyModel.UserView?

    // Tab index -> Submodule
    private var submodules: [Int: ProfileScreenSubmoduleProtocol] = [:]
    
    init(profileUsername: String) {
        self.profileUsername = profileUsername
    }
    
    func doProfileFetch() {
        self.viewController?.displayNotBlockingActivityIndicator(response: .init(shouldDismiss: false))
        
        let parameters = LemmyModel.User.GetUserDetailsRequest(userId: nil,
                                                               username: profileUsername,
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
                    response: .init(state: .result(data: self.makeHeaderViewData(profile: response.user)))
                )
            }.store(in: &cancellable)
    }
    
    func doSubmoduleControllerAppearanceUpdate(request: ProfileScreenDataFlow.SubmoduleAppearanceUpdate.Request) {
        self.submodules[request.submoduleIndex]?.handleControllerAppearance()
    }
    
    func doSubmodulesRegistration(request: ProfileScreenDataFlow.SubmoduleRegistration.Request) {
        for (key, value) in request.submodules {
            self.submodules[key] = value
        }
        self.pushCurrentCourseToSubmodules(submodules: Array(self.submodules.values))
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
    
    private func pushCurrentCourseToSubmodules(submodules: [ProfileScreenSubmoduleProtocol]) {
        submodules.forEach { $0.update() }
    }
}

enum ProfileScreenDataFlow {
    enum Tab {
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
    
    /// Handle submodule controller appearance
    enum SubmoduleAppearanceUpdate {
        struct Request {
            let submoduleIndex: Int
        }
    }
    
    /// Register submodules
    enum SubmoduleRegistration {
        struct Request {
            var submodules: [Int: ProfileScreenSubmoduleProtocol]
        }
    }
    
    enum ShowingActivityIndicator {
        struct Response {
            let shouldDismiss: Bool
        }
    }
    
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenHeaderView.ViewData)
    }
}
