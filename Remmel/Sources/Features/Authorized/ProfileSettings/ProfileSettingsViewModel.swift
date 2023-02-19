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
    func doRemoteProfileSettingsUpdate(request: ProfileSettings.UpdateProfileSettings.Request)
}

// MARK: - ProfileSettingsViewModel -

final class ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {
    
    weak var viewController: ProfileSettingsViewControllerProtocol?
    
    private var userAccountService: UserAccountSerivceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(userAccountService: UserAccountSerivceProtocol) {
        self.userAccountService = userAccountService
    }
    
    func doProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.Request) {
        viewController?.displayLoadingIndicator(viewModel: .init(isLoading: true))
        
        guard let currentUserJwt = userAccountService.jwtToken else {
            viewController?.displayLoadingIndicator(viewModel: .init(isLoading: false))
            return
        }
        
        let params = LMModels.Api.Site.GetSite(auth: currentUserJwt)
        
        ApiManager.requests
            .asyncGetSite(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self?.viewController?.displayError(viewModel: .init(error: error.description, exitImmediately: true))
                }
            } receiveValue: { [weak self] response in
                guard let myUser = response.myUser, let self = self else {
                    self?.displayError()
                    return
                }
                
                self.userAccountService.currentUserInfo = myUser
                
                self.viewController?.displayLoadingIndicator(viewModel: .init(isLoading: false))
                self.viewController?.displayProfileSettingsForm(
                    viewModel: .init(
                        displayName: myUser.localUserView.person.displayName,
                        bio: myUser.localUserView.person.bio,
                        email: myUser.localUserView.localUser.email,
                        matrix: myUser.localUserView.person.matrixUserId,
                        nsfwContent: myUser.localUserView.localUser.showNsfw,
                        notifToEmail: myUser.localUserView.localUser.sendNotificationsToEmail
                    )
                )
            }.store(in: &cancellables)
    }
    
    func doRemoteProfileSettingsUpdate(request: ProfileSettings.UpdateProfileSettings.Request) {
        
        guard let prevData = userAccountService.currentUserInfo,
              let currentUserJwt = userAccountService.jwtToken else {
            return
        }
        let newData = request.data
        
        let params = LMModels.Api.Person.SaveUserSettings(
            showNsfw: newData.showNsfwContent,
            theme: prevData.localUserView.localUser.theme,
            defaultSortType: prevData.localUserView.localUser.defaultSortType.index,
            defaultListingType: prevData.localUserView.localUser.defaultListingType.index,
            interfaceLanguage: prevData.localUserView.localUser.interfaceLanguage,
            avatar: prevData.localUserView.person.avatar?.absoluteString,
            banner: prevData.localUserView.person.banner?.absoluteString,
            displayName: newData.displayName,
            email: newData.email,
            bio: newData.bio,
            matrixUserId: newData.matrix,
            showAvatars: prevData.localUserView.localUser.showAvatars,
            showScores: nil,
            sendNotificationsToEmail: newData.sendNotificationsToEmail,
            botAccount: nil,
            showBotAccounts: nil,
            showReadPosts: nil,
            showNewPostNotifs: nil,
            discussionLanguages: nil,
            auth: currentUserJwt
        )
        
        ApiManager.requests
            .asyncSaveUserSettings(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                Logger.logCombineCompletion(completion)
                
                if case .failure(let error) = completion {
                    self.viewController?.displayError(viewModel: .init(error: error.description,
                                                                       exitImmediately: false))
                }
            } receiveValue: { response in
                self.userAccountService.jwtToken = response.jwt
                self.viewController?.displaySuccessUpdatingSetting()
            }.store(in: &cancellables)
    }
    
    private func displayError() {
        viewController?.displayError(
            viewModel: .init(
                error: "Some error happened when loading user",
                exitImmediately: true
            )
        )
    }
}

// MARK: - ProfileSettings -

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
    
    enum UpdateProfileSettings {
        struct Request {
            let data: ProfileSettingsViewController.TableFormData
        }
        
        struct ViewModel {
            let isOk: Bool
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
