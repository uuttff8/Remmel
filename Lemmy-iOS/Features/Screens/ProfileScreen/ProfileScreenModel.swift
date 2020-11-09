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
}

class ProfileScreenViewModel: ProfileScreenViewModelProtocol {
    private var profileUsername: String
    
    weak var viewController: ProfileScreenViewControllerProtocol?
    
    private var cancellable = Set<AnyCancellable>()
    
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
                self.viewController?.displayProfile(
                    response: .init(state: .result(data: self.makeHeaderViewData(profile: response.user)))
                )
            }.store(in: &cancellable)
    }
    
    private func makeHeaderViewData(
        profile: LemmyModel.UserView
    ) -> ProfileScreenViewController.View.ViewData {
        return ProfileScreenViewController.View.ViewData(
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
    
    enum ShowingActivityIndicator {
        struct Response {
            let shouldDismiss: Bool
        }
    }
    
    enum ViewControllerState {
        case loading
        case result(data: ProfileScreenViewController.View.ViewData)
    }
}
