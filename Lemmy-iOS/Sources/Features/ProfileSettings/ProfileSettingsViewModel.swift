//
//  ProfileSettingsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileSettingsViewModelProtocol: AnyObject {
    func doProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.Request)
}

class ProfileSettingsViewModel: ProfileSettingsViewModelProtocol {
    
    weak var viewController: ProfileSettingsViewControllerProtocol?
    
    private let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func doProfileSettingsForm(request: ProfileSettings.ProfileSettingsForm.Request) {
        self.viewController?.displayProfileSettingsForm(request: .init())
    }
}

enum ProfileSettings {
    
    enum ProfileSettingsForm {
        struct Request { }
        struct ViewModel { }
    }
    
}
