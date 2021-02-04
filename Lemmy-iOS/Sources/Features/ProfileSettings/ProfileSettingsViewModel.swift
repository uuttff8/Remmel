//
//  ProfileSettingsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol ProfileSettingsViewModelProtocol: AnyObject {
    func doProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.Request)
}

class ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {
    
    weak var viewController: ProfileSettingsViewControllerProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.userAccountService = userAccountService
    }
    
    func doProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.Request) {
        self.viewController?.displayLoadingIndicator(viewModel: .init(isLoading: true))
        
        guard let currentUserJwt = userAccountService.jwtToken else {
            self.viewController?.displayLoadingIndicator(viewModel: .init(isLoading: false))
            return
        }
        
        let params = LMModels.Api.Site.GetSite(auth: currentUserJwt)
        
        ApiManager.requests
            .asyncGetSite(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayError(viewModel: .init(error: error.description, exitImmediately: true))
                }
            } receiveValue: { (response) in
                
                guard let user = response.myUser else {
                    self.viewController?.displayError(
                        viewModel: .init(error: "Some error happened when loading user",
                                         exitImmediately: true))
                    return
                }
                
                self.viewController?.displayLoadingIndicator(viewModel: .init(isLoading: false))
                
                self.viewController?.displayProfileSettingsForm(
                    viewModel: .init(displayName: user.preferredUsername,
                                     bio: user.bio,
                                     email: user.email,
                                     matrix: user.matrixUserId,
                                     nsfwContent: user.showNsfw,
                                     notifToEmail: user.sendNotificationsToEmail)
                )
            }.store(in: &cancellables)
    }
}

enum ProfileSettings {
    
    enum ProfileSettingsForm {
        struct Request { }
        struct ViewModel {
            let displayName: String?
            let bio: String?
            let email: String?
            let matrix: String?
            let nsfwContent: Bool
            let notifToEmail: Bool
        }
    }
    
    enum LoadingIndicator {
        struct ViewModel {
            let isLoading: Bool
        }
    }
    
    enum SomeError {
        struct ViewModel {
            let error: String
            let exitImmediately: Bool
        }
    }
    
}
