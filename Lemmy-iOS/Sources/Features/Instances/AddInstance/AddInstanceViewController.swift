//
//  AddInstanceViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol AddInstanceViewControllerProtocol: AnyObject {
    func displayAddInstancePresentation(viewModel: AddInstanceDataFlow.InstancePresentation.ViewModel)
}

final class AddInstanceViewController: UIViewController {
    
    private let viewModel: AddInstanceViewModelProtocol
    
    private lazy var addView = self.view as! AddInstanceView
    
    private lazy var addBarButton = UIBarButtonItem(
        title: "Add",
        style: .done,
        target: self,
        action: #selector(addBarButtonTapped(_:))
    )
    
    private lazy var _activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var loadingBarButton = UIBarButtonItem(customView: _activityIndicator)
    
    init(
        viewModel: AddInstanceViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = AddInstanceView()
        self.view = view
        view.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    @objc
    func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    private func setNewBarButton(loading: Bool) {
        let button = loading == true ? loadingBarButton : addBarButton
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = addBarButton
    }
}

extension AddInstanceViewController: AddInstanceViewControllerProtocol {
    func displayAddInstancePresentation(viewModel: AddInstanceDataFlow.InstancePresentation.ViewModel) {
        
    }
}
extension AddInstanceViewController: AddInstanceViewDelegate {
    func addInstanceView(_ view: AddInstanceView, didTyped text: String) {
        
    }
}
