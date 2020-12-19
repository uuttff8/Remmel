//
//  InstancesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InstancesViewControllerProtocol: AnyObject {
    
}

class InstancesViewController: UIViewController {
    
    weak var coordinator: InstancesCoordinator?
    
    private lazy var createInstanceBarButton = UIBarButtonItem(
        image: UIImage(systemName: "plus.circle"),
        style: .done,
        target: self,
        action: #selector(createInstanceButtonTapped(_:))
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instances"
        
        setupNavigationItem()
    }
    
    @objc func createInstanceButtonTapped(_ action: UIBarButtonItem) {
        // present(!) new view controller through coordinator(!)
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = createInstanceBarButton
    }
}
