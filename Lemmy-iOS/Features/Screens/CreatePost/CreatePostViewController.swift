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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "POST",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(postBarButtonTapped))        
    }
    
    @objc private func postBarButtonTapped() {
        guard let community = model.communitySelected else {
            UIAlertController.createOkAlert(message: "Please select community first")
            return
        }
        guard let titleText = customView.contentCell.titleTextView.text else { return }
        let bodyText = customView.contentCell.bodyTextView.text
        let urlText = customView.urlCell.urlText
        let nsfwOption = customView.contentCell.nsfwSwitch.switcher.isOn
        
        model.createPost(communityId: community.id, title: titleText, body: bodyText, url: urlText, nsfwOption: nsfwOption)
        { (res) in
            switch res {
            case .success(let post):
                DispatchQueue.main.async {
                    self.coordinator?.goToPost(post: post)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CreatePostScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            customView.onPickedImage?(image)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

extension CreatePostScreenViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alertControl = UIAlertController(title: nil, message: "Do you really want to exit", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertControl.addAction(yesAction)
        alertControl.addAction(noAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
