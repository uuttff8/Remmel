//
//  CreatePostViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 20.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostScreenViewController: UIViewController {
    
    weak var coordinator: CreatePostCoordinator?
    
    // MARK: - Properties
    let customView = CreatePostScreenUI()
    
    // MARK: - Overrided
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        title = "Create post"
        
        customView.goToChoosingCommunity = {
            self.coordinator?.goToChoosingCommunity()
        }
    }
}
