//
//  WriteCommentViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol WriteCommentViewControllerProtocol: AnyObject {
    func displayWriteCommentForm(viewModel: WriteComment.FormLoad.ViewModel)
    func displaySuccessCreatingComment(viewModel: WriteComment.RemoteCreateComment.ViewModel)
    func displayCreatePostError(viewModel: WriteComment.CreateCommentError.ViewModel)
}

class WriteCommentViewController: UIViewController {
    
    enum TableForm: String {
        case headerCell
        case textFieldComment
    }
    
    struct FormData {
        var text: String?
    }
    
    lazy var writeCommentView = self.view as! WriteCommentView
    
    private lazy var createBarButton = UIBarButtonItem(
        title: "CREATE",
        style: .done,
        target: self,
        action: #selector(createBarButtonTapped(_:))
    )
    
    private var formData = FormData(text: nil)
    
    private let viewModel: WriteCommentViewModelProtocol
    
    init(viewModel: WriteCommentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = WriteCommentView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Comment"
        self.setupNavigationItems()
        
        self.viewModel.doWriteCommentFormLoad(request: .init())
    }
    
    // MARK: - Objective-c Actions
    @objc func createBarButtonTapped(_ action: UIBarButtonItem) {
        guard let text = formData.text else {
            UIAlertController.createOkAlert(message: "Please enter comment")
            return
        }
        
        self.viewModel.doRemoveCreateComment(request: .init(text: text))
    }
    
    private func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = createBarButton
    }
}

extension WriteCommentViewController: WriteCommentViewControllerProtocol {
    func displayWriteCommentForm(viewModel: WriteComment.FormLoad.ViewModel) {
        let headerCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.headerCell.rawValue,
            type: .rightDetail(
                options: .init(title: .init(text: viewModel.parrentCommentText ?? ""),
                               detailType: .label(text: self.formData.text),
                               accessoryType: .none
                )
            )
        )
        
        let textFieldCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.textFieldComment.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: nil,
                    placeholderText: "Agree!",
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
        
        if viewModel.parrentCommentText != nil {
            sections.insert(
                .init(
                    header: nil,
                    cells: [headerCell],
                    footer: nil
                ), at: 0)
        }
        
        let viewModel = SettingsTableViewModel(sections: sections)
        self.writeCommentView.configure(viewModel: viewModel)
    }
    
    func displaySuccessCreatingComment(viewModel: WriteComment.RemoteCreateComment.ViewModel) {
        self.dismiss(animated: true)
    }
    
    func displayCreatePostError(viewModel: WriteComment.CreateCommentError.ViewModel) {
        UIAlertController.createOkAlert(message: viewModel.error)
    }

}

// MARK: - UIAdaptivePresentationControllerDelegate -
extension WriteCommentViewController: UIAdaptivePresentationControllerDelegate {
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

extension WriteCommentViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
