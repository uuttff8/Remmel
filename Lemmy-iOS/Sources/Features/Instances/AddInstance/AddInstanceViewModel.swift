//
//  AddInstanceViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

protocol AddInstanceViewModelProtocol: AnyObject {
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request)
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request)
}

final class AddInstanceViewModel: AddInstanceViewModelProtocol {
    
    weak var viewController: AddInstanceViewControllerProtocol?
    
    func doAddInstancePresentation(request: AddInstanceDataFlow.InstancePresentation.Request) {
        self.viewController?.displayAddInstancePresentation(viewModel: .init())
    }
    
    func doAddInstanceCheck(request: AddInstanceDataFlow.InstanceCheck.Request) {
        
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
        }
    }
    
    enum ViewControllerState {
        case result(iconUrl: String)
        case noResult
    }
}
