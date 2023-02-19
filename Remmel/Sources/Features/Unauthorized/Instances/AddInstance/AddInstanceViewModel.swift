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
        
    private var cancellable = Set<AnyCancellable>()
    
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request) {
        viewController?.displayAddInstancePresentation(viewModel: .init())
    }
    
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request) {
        guard let instanceUrl = InstanceUrl(string: request.query) else {
            Logger.common.error("Not valid instance url")
            viewController?.displayAddInstanceCheck(
                viewModel: .init(state: .noResult)
            )
            return
        }
        
        let api = RequestsManager(instanceUrl: instanceUrl)
        
        api
            .asyncGetSite(parameters: .init(auth: nil))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure = completion {
                    Logger.common.error("GetSite request with \(request) completion: \(completion)")
                    self.viewController?.displayAddInstanceCheck(
                        viewModel: .init(state: .noResult)
                    )
                } else {
                    Logger.common.verbose(completion)
                }
            } receiveValue: { response in
                
                self.viewController?.displayAddInstanceCheck(
                    viewModel: .init(
                        state: .result(iconUrl: response.siteView.site.icon, instanceUrl: instanceUrl.rawHost)
                    )
                )
            }.store(in: &cancellable)
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
    
    enum ViewControllerState: Equatable {
        case result(iconUrl: URL?, instanceUrl: String)
        case noResult
    }
}
