//
//  SettingsViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMServices
import RMFoundation

private let API_VERSION = " v0.16.4-rc.3"

protocol SettingsViewModelProtocol: AnyObject {
    func doSettingsForm(request: SettingsDataFlow.SettingsForm.Request)
    func doAppIconSettingsPresentation(request: SettingsDataFlow.AppIconSettingPresentation.Request)
    func doAppIconSettingsUpdate(request: SettingsDataFlow.AppIconSettingUpdate.Request)
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    weak var viewController: SettingsViewControllerProtocol?
    
    private let appIconManager: AppIconManagerProtocol
    
    init(appIconManager: AppIconManagerProtocol) {
        self.appIconManager = appIconManager
    }
    
    func doSettingsForm(request: SettingsDataFlow.SettingsForm.Request) {
        let (appVersion, appBuild) = appInfo()
        self.viewController?.displaySettingsForm(
            viewModel: .init(appVersion: appVersion, appBuild: appBuild, apiVersion: API_VERSION)
        )
    }
    
    func doAppIconSettingsPresentation(request: SettingsDataFlow.AppIconSettingPresentation.Request) {
        
        let settingDescription = SettingsDataFlow.SettingDescription(
            settings: appIconManager.availableIcons.map {
                .init(
                    uniqueIdentifier: $0.rawValue,
                    title: "" //FormatterHelper.humanReadableAppIconName(appIcon: $0)
                )
            },
            currentSetting: .init(
                uniqueIdentifier: appIconManager.current.rawValue,
                title:""// FormatterHelper.humanReadableAppIconName(appIcon: appIconManager.current)
            )
        )
        
        viewController?.displayAppIconSetting(
            viewModel: .init(
                settingDescription: settingDescription
            )
        )
    }
    
    func doAppIconSettingsUpdate(request: SettingsDataFlow.AppIconSettingUpdate.Request) {
        let newAppIcon = LemmyAppIcon(rawValue: request.setting.uniqueIdentifier) ?? .white
        Task {
            await appIconManager.setIcon(newAppIcon)
        }
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
    
    enum AppIconSettingPresentation {
        struct Request { }
        
        struct ViewModel {
            let settingDescription: SettingDescription
        }
    }
    
    enum AppIconSettingUpdate {
        struct Request {
            let setting: SettingDescription.Setting
        }
    }
    
    struct SettingDescription {
        let settings: [Setting]
        let currentSetting: Setting?

        struct Setting: UniqueIdentifiable {
            let uniqueIdentifier: UniqueIdentifierType
            let title: String
        }
    }
}
