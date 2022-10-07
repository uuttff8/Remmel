//
//  SettingsViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import MessageUI

protocol SettingsViewControllerProtocol: AnyObject {
    func displaySettingsForm(viewModel: SettingsDataFlow.SettingsForm.ViewModel)
    func displayAppIconSetting(viewModel: SettingsDataFlow.AppIconSettingPresentation.ViewModel)
}

class SettingsViewController: UIViewController, CatalystDismissable {
    
    enum TableForm: String {
        case authorTwitter
        case authorGithub
        case authorTelegram
        case contactEmail
        case contactMatrix
        case openSource
        case changeInstance
        case applicationIcon
        case applicationVersion
        case applicationBuild
        case applicationApiVersion
    }
    
    weak var coordinator: FrontPageCoordinator?
    private let viewModel: SettingsViewModel
    private lazy var settingsView = view as? SettingsView
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissSelf)
    )
    
    init(
        viewModel: SettingsViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = SettingsView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://stackoverflow.com/questions/32696615/warning-attempt-to-present-on-which-is-already-presenting-null
        self.definesPresentationContext = true
        
        title = "settings-appinfo".localized
        self.navigationItem.rightBarButtonItem = closeBarButton
        self.viewModel.doSettingsForm(request: .init())
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.dismissWithExitButton(presses: presses)
    }
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    private func sendEmail(to recipient: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipient])
            mail.setMessageBody("<p>Hello!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
}

extension SettingsViewController: SettingsViewControllerProtocol {
    func displayAppIconSetting(viewModel: SettingsDataFlow.AppIconSettingPresentation.ViewModel) {
        self.displaySelectionList(
            settingDescription: viewModel.settingDescription,
            title: "settings-appicon".localized,
            onSettingSelected: {
                [weak self] settingSelected in
                
                self?.viewModel.doAppIconSettingsUpdate(request: .init(setting: settingSelected))
            }
        )
    }
    
    func displaySettingsForm(viewModel: SettingsDataFlow.SettingsForm.ViewModel) {
        let authorGhCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.authorGithub.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "Github"),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let authorTwitterCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.authorTwitter.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "Twitter"),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let authorTelegramCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.authorTelegram.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "Telegram"),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let contactEmail = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.contactEmail.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "Email"),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let contactMatrix = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.contactMatrix.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "settings-community-matrix".localized),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let openSourceCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.openSource.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "settings-opensource-code".localized),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let instancesChangeInstance = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.changeInstance.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(
                        text: "settings-instances-change-instance".localized,
                        appearance: .init(textColor: .systemRed, textAlignment: .natural)
                        ),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            )
        )
        
        let appIcon = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.applicationIcon.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "settings-appicon".localized),
                    detailType: .label(text: nil),
                    accessoryType: .disclosureIndicator
                )
            )
        )
        
        let appVersion = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.applicationVersion.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "settings-version".localized),
                    detailType: .label(text: viewModel.appVersion),
                    accessoryType: .none
                )
            )
        )
        
        let appBuild = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.applicationBuild.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "settings-build".localized),
                    detailType: .label(text: viewModel.appBuild),
                    accessoryType: .none
                )
            )
        )
        
        let apiVersion = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.applicationApiVersion.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "settings-api-version".localized),
                    detailType: .label(text: viewModel.apiVersion),
                    accessoryType: .none
                )
            )
        )
        
        let sectionsViewModel: [SettingsTableSectionViewModel] = [
            .init(
                header: .init(title: "settings-author".localized),
                cells: [authorGhCell, authorTwitterCell, authorTelegramCell],
                footer: nil
            ),
            .init(
                header: .init(title: "settings-contactinfo".localized),
                cells: [contactEmail, contactMatrix],
                footer: nil
            ),
            .init(
                header: .init(title: "settings-opensource".localized),
                cells: [openSourceCell],
                footer: nil
            ),
            .init(
                header: .init(title: "settings-instances".localized),
                cells: [instancesChangeInstance],
                footer: nil
            ),
            .init(
                header: .init(title: "settings-app".localized),
                cells: [appIcon, appVersion, appBuild, apiVersion],
                footer: nil
            )
        ]
        
        settingsView?.configure(viewModel: SettingsTableViewModel(sections: sectionsViewModel))

    }
    
    private func displaySelectionList(
        settingDescription: SettingsDataFlow.SettingDescription,
        title: String? = nil,
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        onSettingSelected: ((SettingsDataFlow.SettingDescription.Setting) -> Void)? = nil
    ) {
        let selectedCellViewModel: SelectItemViewModel.Section.Cell? = {
            if let currentSetting = settingDescription.currentSetting {
                return .init(uniqueIdentifier: currentSetting.uniqueIdentifier, title: currentSetting.title)
            }
            return nil
        }()

        let viewController = SelectItemTableViewController(
            style: .insetGrouped,
            viewModel: .init(
                sections: [
                    .init(
                        cells: settingDescription.settings.map {
                            .init(uniqueIdentifier: $0.uniqueIdentifier, title: $0.title)
                        },
                        headerTitle: headerTitle,
                        footerTitle: footerTitle
                    )
                ],
                selectedCell: selectedCellViewModel
            ),
            onItemSelected: { selectedCellViewModel in
                let selectedSetting = SettingsDataFlow.SettingDescription.Setting(
                    uniqueIdentifier: selectedCellViewModel.uniqueIdentifier,
                    title: selectedCellViewModel.title
                )
                onSettingSelected?(selectedSetting)
            }
        )

        viewController.title = title

        push(module: viewController)
    }
}

extension SettingsViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}

extension SettingsViewController: SettingsViewDelegate {
    func settingsTableView(
        _ tableView: SettingsTableView,
        didSelectCell cell: SettingsTableSectionViewModel.Cell,
        at indexPath: IndexPath
    ) {
        switch cell.uniqueIdentifier {
        case TableForm.authorGithub.rawValue:
            guard let myGh = URL(string: "https://github.com/uuttff8/") else {
                return
            }

            self.coordinator?.goToBrowser(with: myGh, inApp: false)
        case TableForm.authorTwitter.rawValue:
            guard let myGh = URL(string: "https://twitter.com/babnikbezbab/") else {
                return
            }

            self.coordinator?.goToBrowser(with: myGh, inApp: false)
        case TableForm.authorTelegram.rawValue:
            guard let myGh = URL(string: "https://t.me/uuttff8/") else {
                return
            }

            self.coordinator?.goToBrowser(with: myGh, inApp: false)
        case TableForm.contactEmail.rawValue:
            self.sendEmail(to: "uuttff8@gmail.com")
        case TableForm.contactMatrix.rawValue:
            guard let url = URL(string: "https://matrix.to/#/%23lemmy:matrix.org") else {
                return
            }

            self.coordinator?.goToBrowser(with: url, inApp: false)
        case TableForm.changeInstance.rawValue:
            self.coordinator?.goToInstances()
        case TableForm.openSource.rawValue:
            guard let url = URL(string: "https://github.com/uuttff8/Lemmy-iOS") else {
                return
            }
            
            self.coordinator?.goToBrowser(with: url, inApp: false)
        case TableForm.applicationIcon.rawValue:
            self.viewModel.doAppIconSettingsPresentation(request: .init())
        default:
            break
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
