//
//  SettingsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

private let API_VERSION = "v0.9.0-rc.16"

protocol SettingsViewModelProtocol: AnyObject {
    func doSettingsForm(request: SettingsDataFlow.SettingsForm.Request)
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    weak var viewController: SettingsViewControllerProtocol?
    
    func doSettingsForm(request: SettingsDataFlow.SettingsForm.Request) {
        let info = appInfo()
        self.viewController?.displaySettingsForm(
            viewModel: .init(appVersion: info.0, appBuild: info.1, apiVersion: API_VERSION)
        )
    }
    
    private func appInfo() -> (String, String) {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ("Error finding AppVersion", "")
        }
        
        guard let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return ("", "Error finding AppBuild")
        }
        
        return (appVersion, appBuild)
    }
}

enum SettingsDataFlow {
    
    enum SettingsForm {
        struct Request { }
        
        struct ViewModel {
            let appVersion: String
            let appBuild: String
            let apiVersion: String
        }
    }
    
}
