//
//  EditPostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMFoundation

protocol EditPostViewControllerProtocol: AnyObject {
    func displayEditPostForm(viewModel: EditPost.FormLoad.ViewModel)
    func displaySuccessEditingPost(viewModel: EditPost.RemoteEditPost.ViewModel)
    func displayEditPostError(viewModel: EditPost.CreatePostError.ViewModel)
    func displayUrlLoadImage(viewModel: EditPost.RemoteLoadImage.ViewModel)
    func displayErrorUrlLoadImage(viewModel: EditPost.ErrorRemoteLoadImage.ViewModel)
}

class EditPostViewController: UIViewController {
    
    var completionHandler: (() -> Void)?
    
    enum TableForm: String {
        case headerCell
        case name
        case url
        case body
        case nsfw
        
        init?(uniqueIdentifier: UniqueIdentifierType) {
            if let value = TableForm(rawValue: uniqueIdentifier) {
                self = value
            } else {
                return nil
            }
        }
    }
    
    struct FormData {
        var headerText: String
        var name: String
        var url: String?
        var body: String?
        var nsfw: Bool
    }
    
    lazy var editPostView = self.view as? EditPostView
    
    private lazy var createBarButton = UIBarButtonItem(
        title: "action-create".localized.uppercased(),
        style: .done,
        target: self,
        action: #selector(createBarButtonTapped(_:))
    )
    
    private var formData = FormData(headerText: "", name: "", url: nil, body: "", nsfw: false)
    
    private lazy var imagePickerController: UIImagePickerController = {
        $0.delegate = self
        $0.allowsEditing = false
        $0.sourceType = .photoLibrary
        return $0
    }(UIImagePickerController())
    
    private let viewModel: EditPostViewModelProtocol
    
    // TODO: refactor this
    private var inputWithImageCell: SettingsInputWithImageTableViewCell?
    
    init(viewModel: EditPostViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = EditPostView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "create-comment".localized
        self.setupNavigationItems()
        
        self.viewModel.doEditPostFormLoad(request: .init())
    }
    
    // MARK: - Objective-c Actions
    @objc func createBarButtonTapped(_ action: UIBarButtonItem) {
        guard !self.formData.name.isEmpty else {
            UIAlertController.createOkAlert(message: "create-comment-placeholder".localized)
            return
        }
        
        self.viewModel.doRemoteEditPost(request: .init(name: self.formData.name,
                                                       body: self.formData.body,
                                                       url: self.formData.url,
                                                       nsfw: self.formData.nsfw))
    }
    
    private func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = createBarButton
    }
    
    private func updateUrlState(
        for cell: SettingsInputWithImageTableViewCell, state: SettingsInputWithImageCellView.UrlState
    ) {
        // to update data
        defer {
            self.updateTableViewModel()
        }
        print("update for state: \(state)")
        cell.urlState = state
        
        self.inputWithImageCell = cell
        
        switch state {
        case .notAdded:
            cell.elementView.hideLoading()
            self.present(imagePickerController, animated: true)
        case .loading:
            cell.elementView.showLoading()
            cell.elementView.textFieldIsEnabled = false
            cell.elementView.title = nil
            cell.elementView.imageIcon = Config.Image.close
        case .addWithImage(let text):
            cell.elementView.hideLoading()
            cell.elementView.textFieldIsEnabled = false
            cell.elementView.title = text
            cell.elementView.imageIcon = Config.Image.close
            cell.urlState = .urlAdded
            self.formData.url = text
        case .urlAdded:
            cell.elementView.textFieldIsEnabled = true
            cell.elementView.title = nil
            cell.elementView.imageIcon = Config.Image.addImage
            cell.urlState = .notAdded // for future presenting
            self.formData.url = nil
        case .error:
            cell.urlState = .notAdded
            cell.elementView.hideLoading()
            cell.elementView.textFieldIsEnabled = true
            cell.elementView.title = nil
            cell.elementView.imageIcon = Config.Image.addImage
            self.formData.url = nil
        }
    }
}

extension EditPostViewController: EditPostViewControllerProtocol {
    func displayEditPostForm(viewModel: EditPost.FormLoad.ViewModel) {
        self.formData.name = viewModel.name
        self.formData.body = viewModel.body
        self.formData.nsfw = viewModel.nsfw
        self.formData.url = viewModel.url
        self.formData.headerText = viewModel.headerText
        
        let sections = getSections()
        
        let viewModel = SettingsTableViewModel(sections: sections)
        editPostView?.configure(viewModel: viewModel)
    }
    
    func displayUrlLoadImage(viewModel: EditPost.RemoteLoadImage.ViewModel) {
        guard let inputWithImageCell = inputWithImageCell else {
            return
        }
        updateUrlState(for: inputWithImageCell, state: .addWithImage(text: viewModel.url))
    }
    
    func displayErrorUrlLoadImage(viewModel: EditPost.ErrorRemoteLoadImage.ViewModel) {
        guard let inputWithImageCell = inputWithImageCell else {
            return
        }
        
        UIAlertController.createOkAlert(message: "Some error happened when uploading a picture")
        updateUrlState(for: inputWithImageCell, state: .error)
    }
    
    func updateTableViewModel() {
        let sections = getSections()
        let viewModel = SettingsTableViewModel(sections: sections)
        editPostView?.updateViewModel(viewModel)
    }
    
    private func getSections() -> [SettingsTableSectionViewModel] {
        let headerCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.headerCell.rawValue,
            type: .rightDetail(
                options: .init(title: .init(text: self.formData.headerText),
                               accessoryType: .none
                )
            )
        )
        
        let urlCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.url.rawValue,
            type: .inputWithImage(
                options: .init(
                    placeholderText: "create-content-create-url-placeholder".localized,
                    valueText: self.formData.url,
                    imageIcon: Config.Image.addImage
                )
            )
        )
        
        let nameCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.name.rawValue,
            type: .input(
                options: .init(
                    valueText: self.formData.name,
                    placeholderText: "Haha"
                )
            )
        )
        
        let bodyCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.body.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: self.formData.body,
                    placeholderText: "create-content-create-body-placeholder".localized,
                    maxLength: nil
                )
            )
        )
        
        let nsfwCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.nsfw.rawValue,
            type: .rightDetail(
                options: .init(
                    title: .init(text: "create-content-create-nsfw".localized),
                    detailType: .switch(
                        .init(isOn: self.formData.nsfw)
                    ),
                    accessoryType: .none
                )
            )
        )
                
        let sections: [SettingsTableSectionViewModel] = [
            SettingsTableSectionViewModel(
                header: nil,
                cells: [headerCell],
                footer: nil
            ),
            SettingsTableSectionViewModel(
                header: .init(title: "create-content-create-url".localized),
                cells: [urlCell],
                footer: nil
            ),
            SettingsTableSectionViewModel(
                header: nil,
                cells: [nameCell, bodyCell],
                footer: nil
            ),
            SettingsTableSectionViewModel(
                header: nil,
                cells: [nsfwCell],
                footer: nil
            )
        ]
        
        return sections

    }
    
    func displaySuccessEditingPost(viewModel: EditPost.RemoteEditPost.ViewModel) {
        self.dismiss(animated: true)
        completionHandler?()
    }
    
    func displayEditPostError(viewModel: EditPost.CreatePostError.ViewModel) {
        UIAlertController.createOkAlert(message: viewModel.error)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate -
extension EditPostViewController: UIAdaptivePresentationControllerDelegate {
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
extension EditPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            guard let inputWithImageCell = inputWithImageCell else {
                return
            }
            
            self.updateUrlState(for: inputWithImageCell, state: .loading)
            self.viewModel.doRemoteLoadImage(request: .init(image: image, filename: imageUrl.lastPathComponent))
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditPostViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}

extension EditPostViewController: EditPostViewDelegate {
    
    private func handleTextField(uniqueIdentifier: UniqueIdentifierType?, text: String?) {
        guard let id = uniqueIdentifier, let field = TableForm(uniqueIdentifier: id) else {
            return
        }
        
        switch field {
        case .name:
            self.formData.name = text ?? ""
        case .body:
            self.formData.body = text
        default: return
        }
        
        // safe changes
        self.updateTableViewModel()
    }

    func settingsCell(
        elementView: UITextView,
        didReportTextChange text: String,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCell(
        elementView: UITextField,
        didReportTextChange text: String?,
        identifiedBy uniqueIdentifier: UniqueIdentifierType?
    ) {
        self.handleTextField(uniqueIdentifier: uniqueIdentifier, text: text)
    }
    
    func settingsCellDidTappedToIcon(_ cell: SettingsInputWithImageTableViewCell) {
        updateUrlState(for: cell, state: cell.urlState)
    }
}
