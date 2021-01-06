//
//  WriteMessageViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol WriteMessageViewControllerProtocol: AnyObject {
    func displayWriteMessageForm(viewModel: WriteMessage.FormLoad.ViewModel)
    func displaySuccessCreatingMessage(viewModel: WriteMessage.RemoteCreateComment.ViewModel)
    func displayCreateMessageError(viewModel: WriteMessage.CreateCommentError.ViewModel)
}

class WriteMessageViewController: UIViewController {
    
    enum TableForm: String {
        case headerCell
        case textFieldComment
    }
    
    struct FormData {
        var text: String?
    }
    
    lazy var writeMessageView = self.view as! WriteMessageView
    
    private lazy var createBarButton = UIBarButtonItem(
        title: "CREATE",
        style: .done,
        target: self,
        action: #selector(createBarButtonTapped(_:))
    )
    
    private var formData = FormData(text: nil)
    
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
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Message"
        self.setupNavigationItems()
        
        self.viewModel.doWriteCommentFormLoad(request: .init())
    }
    
    // MARK: - Objective-c Actions
    @objc func createBarButtonTapped(_ action: UIBarButtonItem) {
        guard let text = formData.text else {
            UIAlertController.createOkAlert(message: "Please enter a message")
            return
        }
        
        self.viewModel.doRemoveCreateComment(request: .init(text: text))
    }
    
    private func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = createBarButton
    }
}

extension WriteMessageViewController: WriteMessageViewControllerProtocol {
    func displayWriteMessageForm(viewModel: WriteMessage.FormLoad.ViewModel) {
        
        let textFieldCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.textFieldComment.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: nil,
                    placeholderText: "not absolute private message here!",
                    maxLength: nil
                )
            )
        )
                
        let sections: [SettingsTableSectionViewModel] = [
            .init(
                header: nil,
                cells: [textFieldCell],
                footer: nil
            )
        ]
                
        let viewModel = SettingsTableViewModel(sections: sections)
        self.writeMessageView.configure(viewModel: viewModel)
    }
    
    func displaySuccessCreatingMessage(viewModel: WriteMessage.RemoteCreateComment.ViewModel) {
        self.dismiss(animated: true)
    }
    
    func displayCreateMessageError(viewModel: WriteMessage.CreateCommentError.ViewModel) {
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

