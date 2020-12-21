//
//  AddInstanceViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol AddInstanceViewModelProtocol: AnyObject {
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request)
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request)
}

final class AddInstanceViewModel: AddInstanceViewModelProtocol {
    
    weak var viewController: AddInstanceViewControllerProtocol?
    
    private let userAccountService: UserAccountSerivceProtocol
    
    private var cancellable = Set<AnyCancellable>()
    
    init(userAccountService: UserAccountSerivceProtocol) {
        self.userAccountService = userAccountService
    }
    
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request) {
        self.viewController?.displayAddInstancePresentation(viewModel: .init())
    }
    
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request) {
        ApiManager(instanceUrl: request.query)
            .requestsManager
            .asyncGetSite(parameters: .init(auth: userAccountService.jwtToken))
            .receive(on: RunLoop.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    print(completion)
                case .failure:
                    self.viewController?.displayAddInstanceCheck(
                        viewModel: .init(state: .noResult)
                    )
                }
            } receiveValue: { (response) in
                
                let instance = Instance(entity: Instance.entity(), insertInto: CoreDataHelper.shared.context)
                var query = request.query
                instance.label = String.cleanUpUrl(url: &query)
                CoreDataHelper.shared.save()
                
                self.viewController?.displayAddInstanceCheck(
                    viewModel: .init(state: .result(iconUrl: response.site?.icon))
                )
            }.store(in: &self.cancellable)
        
    }
}

enum AddInstanceDataFlow {
    
    enum InstancePresentation {
        struct Request { }
        
        struct ViewModel { }
    }
    
    enum InstanceCheck {
        struct Request {
            let query: String
        }
        
        struct ViewModel {
            let state: ViewControllerState
        }
    }
    
    enum ViewControllerState {
        case result(iconUrl: String?)
        case noResult
    }
}
