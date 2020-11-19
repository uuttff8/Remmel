//
//  CreatePostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: CreatePostCoordinator?
    
    lazy var customView = CreatePostScreenUI(model: model)
    let model = CreatePostScreenModel()
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - Overrided
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create post"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        customView.onPickImage = {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        customView.goToChoosingCommunity = { [self] in
            coordinator?.goToChoosingCommunity(model: model)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "POST",
            primaryAction: UIAction(handler: postBarButtonTapped),
            style: .done
        )
    }
    
    // MARK: - Action
    private func postBarButtonTapped(_ action: UIAction) {
        guard let community = model.communitySelected else {
            UIAlertController.createOkAlert(message: "Please select community first")
            return
        }
        guard let titleText = customView.contentCell.titleTextView.text else { return }
        let bodyText = customView.contentCell.bodyTextView.text
        let urlText = /*customView.urlCell.urlText*/ ""
        let nsfwOption = customView.contentCell.nsfwSwitch.switcher.isOn
        
        let data = CreatePostScreenModel.CreatePostData(
            communityId: community.id,
            title: titleText,
            body: bodyText,
            url: urlText,
            nsfwOption: nsfwOption
        )
        
        model.createPost(
            data: data
        ) { (res) in
            
            switch res {
            case .success(let post):
                DispatchQueue.main.async {
                    self.coordinator?.goToPost(post: post)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    UIAlertController.createOkAlert(message: error.localizedDescription)
                }
                print(error)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate -
extension CreatePostScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            customView.onPickedImage?(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate -
extension CreatePostScreenViewController: UIAdaptivePresentationControllerDelegate {
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
