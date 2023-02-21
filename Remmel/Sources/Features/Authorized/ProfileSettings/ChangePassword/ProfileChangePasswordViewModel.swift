//
//  ProfileChangePasswordViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.05.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine
import RMNetworking
import RMModels

protocol ProfileChangePasswordViewModelProtocol: AnyObject {
    func doReceiveMessages()
    func doProfileChangePasswordForm(request: ProfileChangePassword.Form.Request)
    func doChangePassword(request: ProfileChangePassword.ChangePassword.Request)
}

final class ProfileChangePasswordViewModel: ProfileChangePasswordViewModelProtocol {
    weak var viewContoller: ProfileChangePasswordViewControllerProtocol?
    
    private weak var wsClient: WSClientProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(wsClient: WSClientProtocol) {
        self.wsClient = wsClient
    }

    func doReceiveMessages() {
        self.wsClient?.onTextMessage.addObserver(self, completionHandler: { [weak self] operation, data in
            guard let self = self else {
                return
            }
            
            switch operation {
            case RMUserOperation.ChangePassword.rawValue:
                guard let login = self.wsClient?.decodeWsType(
                    RMModels.Api.Person.LoginResponse.self,
                    data: data
                ) else { return }
                
                guard let jwt = login.jwt else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.viewContoller?.displaySucessChangingPassword(viewModel: .success(jwt: jwt))
                }
                
            default: break
            }
        })
    }
    
    func doProfileChangePasswordForm(request: ProfileChangePassword.Form.Request) {
        self.viewContoller?.displayProfileChangePasswordForm(viewModel: .init())
    }
    
    func doChangePassword(request: ProfileChangePassword.ChangePassword.Request) {
        
    }
}

enum ProfileChangePassword {
    enum Form {
        struct Request { }
        struct ViewModel { }
    }
    
    enum ChangePassword {
        struct Request {
            let oldPassword: String
            let newPassword: String
            let verifyPassword: String
        }
        
        struct ViewModel {
            let jwt: String
        }
    }
    
    enum ChangePasswordResult {
        case success(jwt: String)
        case failed(error: String)
    }
}
