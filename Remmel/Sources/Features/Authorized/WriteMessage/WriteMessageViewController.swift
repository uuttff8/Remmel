//
//  WriteMessageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation

protocol WriteMessageViewControllerProtocol: AnyObject {
    func displayWriteMessageForm(viewModel: WriteMessage.FormLoad.ViewModel)
    func displaySuccessCreatingMessage(viewModel: WriteMessage.RemoteCreateMessage.ViewModel)
    func displayCreateMessageError(viewModel: WriteMessage.CreateMessageError.ViewModel)
}

class WriteMessageViewController: UIViewController {
    
    var completionHandler: (() -> Void)?
    
    enum TableForm: String {
        case headerCell
        case textFieldMessage
        
        init?(uniqueIdentifier: UniqueIdentifierType) {
            if let value = TableForm(rawValue: uniqueIdentifier) {
                self = value
            } else {
                return nil
            }
        }
    }
    
    struct FormData {
        var headerText: String?
        var text: String?
    }
    
    private var formData = FormData(headerText: nil, text: nil)
    
    lazy var writeMessageView = self.view as? WriteMessageView
    
    private lazy var createBarButton = UIBarButtonItem(
        title: "action-create".localized.uppercased(),
        style: .done,
        target: self,
        action: #selector(createBarButtonTapped(_:))
    )
        
    private let viewModel: WriteMessageViewModelProtocol
    
    init(viewModel: WriteMessageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = WriteMessageView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch viewModel.action {
        case .edit:
            title = "Edit Comment"
        case .replyToPrivateMessage:
            title = "Reply"
        case .writeComment:
            title = "New Comment"
        }
        
        self.setupNavigationItems()
        
        self.viewModel.doWriteMessageFormLoad(request: .init())
    }
    
    // MARK: - Objective-c Actions
    @objc func createBarButtonTapped(_ action: UIBarButtonItem) {
        guard let text = formData.text else {
            UIAlertController.createOkAlert(message: "Please enter a message")
            return
        }
        
        self.viewModel.doRemoteCreateMessage(request: .init(text: text))
    }
    
    private func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = createBarButton
    }
}

extension WriteMessageViewController: WriteMessageViewControllerProtocol {
    func displayWriteMessageForm(viewModel: WriteMessage.FormLoad.ViewModel) {
        self.formData.headerText = viewModel.headerText
        
        switch self.viewModel.action {
        case .edit(comment: let comment):
            self.formData.text = comment.content
        default: break
        }
        
        let sections = getSections()
        
        let viewModel = SettingsTableViewModel(sections: sections)
        writeMessageView?.configure(viewModel: viewModel)
    }
    
    func updateViewModel() {
        let sections = getSections()
        
        let viewModel = SettingsTableViewModel(sections: sections)
        writeMessageView?.updateViewModel(viewModel: viewModel)
    }
    
    private func getSections() -> [SettingsTableSectionViewModel] {
        let headerCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.headerCell.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: self.formData.headerText ?? ""),
                    detailType: .label(text: nil),
                    accessoryType: .none
                )
            ),
            appearance: .init(selectionStyle: .none)
        )
        
        let textFieldCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.textFieldMessage.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: self.formData.text,
                    placeholderText: "create-comment-agree".localized,
                    maxLength: nil
                )
            )
        )
                
        var sections: [SettingsTableSectionViewModel] = [
            .init(
                header: nil,
                cells: [textFieldCell],
                footer: nil
            )
        ]
        
        if let headerText = formData.headerText, !headerText.isEmpty {
            sections.insert(
                .init(
                    header: nil,
                    cells: [headerCell],
                    footer: nil
                ), at: 0)
        }
        
        return sections
    }
    
    func displaySuccessCreatingMessage(viewModel: WriteMessage.RemoteCreateMessage.ViewModel) {
        self.dismiss(animated: true)
        self.completionHandler?()
    }
    
    func displayCreateMessageError(viewModel: WriteMessage.CreateMessageError.ViewModel) {
        UIAlertController.createOkAlert(message: viewModel.error)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate -
extension WriteMessageViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        
        let alertControl = UIAlertController.Configurations.reallyWantToExit(
            onYes: {
                self.dismiss(animated: true, completion: nil)
            }
        )
        
        present(alertControl, animated: true, completion: nil)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}

extension WriteMessageViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}

extension WriteMessageViewController: WriteMessageViewDelegate {
    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        guard let id = uniqueIdentifier, let field = TableForm(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .textFieldMessage:
            self.formData.text = text
        default: return
        }
        
        updateViewModel()
    }
}
