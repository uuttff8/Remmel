//
//  AccountsViewModel.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 24/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Combine
import Foundation

protocol AccountsViewModelProtocol: AnyObject {
    func doAccountsRefresh(request: AccountsDataFlow.AccountsRefresh.Request)
    func doAccountDelete(request: AccountsDataFlow.AccountDelete.Request)
}

final class AccountsViewModel: AccountsViewModelProtocol {
    weak var viewController: AccountsViewControllerProtocol?
    
    let currentInstance: Instance
    
    private let accountsPersistenceService: AccountsPersistenceServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        instance: Instance,
        accountsPersistenceService: AccountsPersistenceServiceProtocol
    ) {
        self.currentInstance = instance
        self.accountsPersistenceService = accountsPersistenceService
    }
    
    func doAccountsRefresh(request: AccountsDataFlow.AccountsRefresh.Request) {
        self.viewController?.displayAccounts(
            viewModel: .init(state: .result(data: self.currentInstance.accounts))
        )
    }
    
    func doAccountDelete(request: AccountsDataFlow.AccountDelete.Request) {
        self.accountsPersistenceService.delete(request.account)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {})
            .store(in: &cancellables)
    }

}

enum AccountsDataFlow {
    
    enum AccountsRefresh {
        struct Request { }
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum AccountDelete {
        struct Request {
            let account: Account
        }
        
        struct ViewModel { }
    }
    
    enum ViewControllerState {
        case loading
        case result(data: [Account])
    }
}
