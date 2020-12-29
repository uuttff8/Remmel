//
//  AddAccountsViewModel.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol AddAccountViewModelProtocol {
    func doRemoteAuthentication(request: AddAccountDataFlow.Authentication.AuthRequest)
    func doRemoteRegister(request: AddAccountDataFlow.Authentication.RegisterRequest)
}

final class AddAccountViewModel: AddAccountViewModelProtocol {
    
    weak var viewController: AddAccountViewControllerProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    let shareData: LemmyShareData
    
    private var authLogin: String?
    private var authPassword: String?
    
    init(shareData: LemmyShareData) {
        self.shareData = shareData
    }
    
    func doRemoteAuthentication(request: AddAccountDataFlow.Authentication.AuthRequest) {
        let parameters = LemmyModel.Authentication.LoginRequest(
            usernameOrEmail: request.emailOrUsername,
            password: request.password
        )
        
        self.saveCredentials(login: request.emailOrUsername, password: request.password)
        
        ApiManager.requests.asyncLogin(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                Logger.logCombineCompletion(completion)
                
                if case let .failure(why) = completion {
                    self.saveCredentials(login: nil, password: nil)
                    self.viewController?.displayErrorAuth(viewModel: .init(error: why.description))
                }
            }, receiveValue: { (response) in
                self.fetchUser(with: response.jwt)
            }).store(in: &cancellables)

    }
    
    func doRemoteRegister(request: AddAccountDataFlow.Authentication.RegisterRequest) {
        let parameters = LemmyModel.Authentication.RegisterRequest(
            username: request.username,
            email: request.email,
            password: request.password,
            passwordVerify: request.passwordVerify,
            admin: false,
            showNsfw: request.showNsfw,
            captchaUuid: request.captchaUuid,
            captchaAnswer: request.captchaAnswer
        )
        
        self.saveCredentials(login: request.username, password: authPassword)
        
        ApiManager.requests.asyncRegister(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                Logger.logCombineCompletion(completion)

                if case let .failure(why) = completion {
                    self.saveCredentials(login: nil, password: nil)
                    self.viewController?.displayErrorAuth(viewModel: .init(error: why.description))
                }
            }, receiveValue: { (response) in
                self.fetchUser(with: response.jwt)
            }).store(in: &cancellables)
    }
    
    private func fetchUser(with jwtToken: String) {
        self.loadUserOnSuccessResponse(jwt: jwtToken) { (currentUser: LemmyModel.MyUser) in
            
            guard let password = self.authPassword,
                  let login = self.authLogin
            else {
                self.viewController?.displayErrorAuth(viewModel: .init(error: "WHY THISS HAPPPENNN????"))
                return
            }
            
            self.viewController?.displaySuccessAuth(
                viewModel: .init(currentUser: currentUser)
            )
        }
    }
    
    private func loadUserOnSuccessResponse(jwt: String, completion: @escaping ((LemmyModel.MyUser) -> Void)) {
//        self.shareData.loginData.login(jwt: jwt)
        
        let params = LemmyModel.Site.GetSiteRequest(auth: jwt)
        
        ApiManager.requests.asyncGetSite(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                Logger.logCombineCompletion(completion)
            }, receiveValue: { (response) in
//                self.shareData.userdata = response.myUser
                
                guard let myUser = response.myUser else { return }
                completion(myUser)
            }).store(in: &cancellables)
    }
    
    private func saveCredentials(login: String?, password: String?) {
        self.authLogin = login
        self.authPassword = password
    }
}

enum AddAccountDataFlow {
    
    // since backend returns LemmyModel.MyUser in both situation, we generalize it
    enum Authentication {
        struct AuthRequest {
            let emailOrUsername: String
            let password: String
        }
        
        struct RegisterRequest {
            let username: String
            let email: String?
            let password: String
            let passwordVerify: String
            let showNsfw: Bool
            let captchaUuid: String?
            let captchaAnswer: String?
        }
        
        struct ViewModel {
            let currentUser: LemmyModel.MyUser
        }
    }
    
    enum AuthError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}
