//
//  AddAccountsViewModel.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMModels
import RMFoundation
import RMNetworking

protocol AddAccountViewModelProtocol {
    func doRemoteAuthentication(request: AddAccountDataFlow.Authentication.AuthRequest)
    func doRemoteRegister(request: AddAccountDataFlow.Authentication.RegisterRequest)
}

final class AddAccountViewModel: AddAccountViewModelProtocol {
    
    weak var viewController: AddAccountViewControllerProtocol?
    
    private let currentInstance: Instance
    
    private var cancellables = Set<AnyCancellable>()
    
    private var authLogin: String?
    private var authPassword: String?
    
    init(
        instance: Instance
    ) {
        self.currentInstance = instance
    }
    
    func doRemoteAuthentication(request: AddAccountDataFlow.Authentication.AuthRequest) {
        let parameters = RMModel.Api.Person.Login(
            usernameOrEmail: request.emailOrUsername,
            password: request.password
        )
        
        self.saveCredentials(login: request.emailOrUsername, password: request.password)
        
        ApiManager.requests.asyncLogin(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                Logger.logCombineCompletion(completion)
                
                if case let .failure(why) = completion {
                    self.saveCredentials(login: nil, password: nil)
                    self.viewController?.displayErrorAuth(viewModel: .init(error: why.description))
                }
            }, receiveValue: { response in
                
                guard let jwt = response.jwt else {
                    return
                }
                
                self.fetchUser(with: jwt)
            }).store(in: &cancellables)

    }
    
    func doRemoteRegister(request: AddAccountDataFlow.Authentication.RegisterRequest) {
        let parameters = RMModel.Api.Person.Register(
            username: request.username,
            email: request.email,
            password: request.password,
            passwordVerify: request.passwordVerify,
            showNsfw: request.showNsfw,
            captchaUuid: request.captchaUuid,
            captchaAnswer: request.captchaAnswer,
            honeypot: nil,
            answer: nil
        )
        
        self.saveCredentials(login: request.username, password: authPassword)
        
        ApiManager.requests.asyncRegister(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                Logger.logCombineCompletion(completion)

                if case let .failure(why) = completion {
                    self.saveCredentials(login: nil, password: nil)
                    self.viewController?.displayErrorAuth(viewModel: .init(error: why.description))
                }
            }, receiveValue: { response in
                
                guard let jwt = response.jwt else {
                    return
                }
                
                self.fetchUser(with: jwt)
            }).store(in: &cancellables)
    }
    
    private func fetchUser(with jwtToken: String) {
        self.loadUserOnSuccessResponse(jwt: jwtToken) { (currentUser: RMModel.Source.PersonSafe) in
            
            guard let password = self.authPassword,
                  let login = self.authLogin
            else {
                self.viewController?.displayErrorAuth(viewModel: .init(error: "WHY THISS HAPPPENNN????"))
                return
            }
            
            let account = Account(entity: Account.entity(), insertInto: CoreDataHelper.shared.context)
            account.login = login
            account.password = password
            account.instance = self.currentInstance
            self.currentInstance.addAccountItemsObject(value: account)

            CoreDataHelper.shared.save()
            
            self.viewController?.displaySuccessAuth(
                viewModel: .init(currentUser: currentUser)
            )
        }
    }
        
    private func loadUserOnSuccessResponse(
        jwt: String,
        completion: @escaping ((RMModel.Source.PersonSafe) -> Void)
    ) {
        
        let params = RMModel.Api.Site.GetSite(auth: jwt)
        
        ApiManager.requests.asyncGetSite(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                Logger.logCombineCompletion(completion)
            }, receiveValue: { response in
                guard let myUser = response.myUser?.localUserView.person else {
                    return
                }
                completion(myUser)
            }).store(in: &cancellables)
    }
    
    private func saveCredentials(login: String?, password: String?) {
        self.authLogin = login
        self.authPassword = password
    }
}

enum AddAccountDataFlow {
    
    // since backend returns RMModel.Source.User_ in both situation, we generalize it
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
            let currentUser: RMModel.Source.PersonSafe
        }
    }
    
    enum AuthError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}
