//
//  InstancesViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol InstancesViewModelProtocol {
    func doInstancesRefresh(request: InstancesDataFlow.InstancesLoad.Request)
    func doAddInstance(request: InstancesDataFlow.AddInstance.Request)
    func doInstanceDelete(request: InstancesDataFlow.DeleteInstance.Request)
}

class InstancesViewModel: InstancesViewModelProtocol {
    
    weak var viewController: InstancesViewControllerProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol
    private let provider: InstancesProviderProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(provider: InstancesProviderProtocol, userAccountService: UserAccountSerivceProtocol) {
        self.provider = provider
        self.userAccountService = userAccountService
    }
    
    func doUnauthState() {
        userAccountService.logOut()
    }
    
    func doInstancesRefresh(request: InstancesDataFlow.InstancesLoad.Request) {
        
        provider.fetchCachedInstances()
            .receive(on: DispatchQueue.main)
            .sink { instances in
                
                self.viewController?.displayInstances(
                    viewModel: .init(state: .result(data: instances))
                )
                
            }.store(in: &cancellable)
        
    }
    
    func doAddInstance(request: InstancesDataFlow.AddInstance.Request) {
        provider.addNewInstance(link: request.link.rawHost)
            .sink(receiveValue: { _ in
                // as a new instance created, take it from db
                self.doInstancesRefresh(request: .init())
            })
            .store(in: &cancellable)
    }
    
    func doInstanceDelete(request: InstancesDataFlow.DeleteInstance.Request) {
        
        provider.delete(request.instance)
            .sink(receiveValue: {})
            .store(in: &cancellable)
    }
}

enum InstancesDataFlow {
    
    enum InstancesLoad {
        struct Request { }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum AddInstance {
        struct Request {
            let link: InstanceUrl
        }
        
        struct ViewModel {
            let instance: Instance
        }
    }
    
    enum DeleteInstance {
        struct Request {
            let instance: Instance
        }
    }
    
    enum ViewControllerState {
        case loading
        case result(data: [Instance])
    }
}
