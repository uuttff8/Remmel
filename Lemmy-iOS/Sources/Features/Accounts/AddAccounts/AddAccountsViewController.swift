//
//  AddAccountsViewController.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol AddAccountsViewControllerDelegate: AnyObject {
//    func displayAddInstancePresentation(viewModel: AddInstanceDataFlow.InstancePresentation.ViewModel)
//    func displayAddInstanceCheck(viewModel: AddInstanceDataFlow.InstanceCheck.ViewModel)
}

final class AddAccountsViewController: UIViewController {
    
    var coordinator: AccountsCoordinator?
    let viewModel: AddAccountsViewModel
    
    private lazy var addBarButton = UIBarButtonItem(
        title: "Add",
        style: .done,
        target: self,
        action: #selector(addBarButtonTapped)
    )
    
    init(viewModel: AddAccountsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = AddAccountsView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        title = "Create Account"
        self.navigationItem.rightBarButtonItem = addBarButton
        addBarButton.isEnabled = false
    }
    
    // MARK: - Actions
    
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {
//        completionHandler?()
        self.dismiss(animated: true)
    }
}
