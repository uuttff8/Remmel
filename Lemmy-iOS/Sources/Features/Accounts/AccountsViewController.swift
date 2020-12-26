//
//  AccountsViewController.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 24/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class AccountsViewController: UIViewController {
    
    var coordinator: AccountsCoordinator?
    let viewModel: AccountsViewModel
    
    private lazy var createAccountBarButton = UIBarButtonItem(
        image: UIImage(systemName: "plus.circle"),
        style: .done,
        target: self,
        action: #selector(createAccountButtonTapped)
    )
    
    init(viewModel: AccountsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = AccountsView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Accounts"
        view.backgroundColor = .white
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = createAccountBarButton
    }
    
    // MARK: - Actions
    
    @objc private func createAccountButtonTapped(sender: UIBarButtonItem) {
        coordinator?.goToAddAccountsModule()
    }
}

