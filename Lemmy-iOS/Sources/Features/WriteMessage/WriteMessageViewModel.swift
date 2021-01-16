//
//  WriteMessageViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol WriteMessageViewModelProtocol: AnyObject {
    func doWriteMessageFormLoad(request: WriteMessage.FormLoad.Request)
    func doRemoteCreateMessage(request: WriteMessage.RemoteCreateMessage.Request)
}

class WriteMessageViewModel: WriteMessageViewModelProtocol {
    weak var viewController: WriteMessageViewControllerProtocol?
    
    private let recipientId: Int

    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(
        recipientId: Int,
        userAccountService: UserAccountSerivceProtocol
    ) {
        self.recipientId = recipientId
        self.userAccountService = userAccountService
    }

    func doWriteMessageFormLoad(request: WriteMessage.FormLoad.Request) {
        self.viewController?.displayWriteMessageForm(viewModel: .init())
    }
    
    func doRemoteCreateMessage(request: WriteMessage.RemoteCreateMessage.Request) {
        guard let jwtToken = userAccountService.jwtToken else {
            Logger.commonLog.error("JWT Token not found: User should not be able to write message when not authed")
            return
        }
        
        let params = LMModels.Api.User.CreatePrivateMessage(
            content: request.text,
            recipientId: recipientId,
            auth: jwtToken
        )
        
        ApiManager.requests.asyncCreatePrivateMessage(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)

                if case .failure(let error) = completion {
                    self.viewController?.displayCreateMessageError(
                        viewModel: .init(error: error.description)
                    )
                }
            } receiveValue: { (response) in
                self.viewController?.displaySuccessCreatingMessage(
                    viewModel: .init(message: response.privateMessageView)
                )
            }.store(in: &self.cancellable)
    }
}

enum WriteMessage {
    enum FormLoad {
        struct Request { }
        
        struct ViewModel { }
    }
    
    enum RemoteCreateMessage {
        struct Request {
            let text: String
        }
        
        struct ViewModel {
            let message: LMModels.Views.PrivateMessageView
        }
    }
    
    enum CreateMessageError {
        struct Request { }
        
        struct ViewModel {
            let error: String
        }
    }
}
