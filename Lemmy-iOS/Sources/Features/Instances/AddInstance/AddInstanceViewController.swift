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
    func displayAddInstanceCheck(viewModel: AddInstanceDataFlow.InstanceCheck.ViewModel)
}

final class AddInstanceViewController: UIViewController {
    
    weak var coordinator: InstancesCoordinator?
    private let viewModel: AddInstanceViewModelProtocol
    
    private lazy var addView = self.view as! AddInstanceView
    
    private lazy var addBarButton = UIBarButtonItem(
        title: "Add",
        style: .done,
        target: self,
        action: #selector(addBarButtonTapped(_:))
    )
    
    private lazy var _activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
    }
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
    
    private func setNewBarButton(loading: Bool, isEnabled: Bool) {
        let button: UIBarButtonItem
        if loading {
            button = loadingBarButton
            addBarButton.isEnabled = isEnabled
        } else {
            button = addBarButton
            addBarButton.isEnabled = isEnabled
        }
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func setupNavigationItem() {
        title = "Create Instance"
        self.navigationItem.rightBarButtonItem = addBarButton
        addBarButton.isEnabled = false
    }
}

extension AddInstanceViewController: AddInstanceViewControllerProtocol {
    func displayAddInstancePresentation(viewModel: AddInstanceDataFlow.InstancePresentation.ViewModel) {
        // nothing
    }
    
    func displayAddInstanceCheck(viewModel: AddInstanceDataFlow.InstanceCheck.ViewModel) {
        switch viewModel.state {
        case .result:
            self.setNewBarButton(loading: false, isEnabled: true)
        case .noResult:
            self.setNewBarButton(loading: false, isEnabled: false)
        }
    }
}
extension AddInstanceViewController: AddInstanceViewDelegate {
    func addInstanceView(_ view: AddInstanceView, didTyped text: String?) {
        self.setNewBarButton(loading: true, isEnabled: false)
        if let text = text {
            self.viewModel.doAddInstanceCheck(request: .init(query: text))
        }
    }
}
