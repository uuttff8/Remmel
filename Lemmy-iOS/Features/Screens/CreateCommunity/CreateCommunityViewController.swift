//
//  CreateCommunityViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinator: CreateCommunityCoordinator?
    
    lazy var customView = CreateCommunityUI(model: model)
    let model = CreateCommunityModel()
    
    // MARK: - Overrided
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        title = "Create community"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "CREATE",
            image: nil,
            primaryAction: UIAction(handler: createBarButtonTapped(action:)),
            menu: nil
        )
    }
    
    // MARK: Actions
    private func createBarButtonTapped(action: UIAction) {
        print("action \(action)")
    }
}

extension CreateCommunityViewController: UIAdaptivePresentationControllerDelegate {
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
