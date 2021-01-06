//
//  InboxMessagesViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMessagesViewControllerProtocol: AnyObject {
    func displayMessages(viewModel: InboxMessages.LoadMessages.ViewModel)
}

final class InboxMessagesViewController: UIViewController {
    
    private let viewModel: InboxMessagesViewModel
    
    init(
        viewModel: InboxMessagesViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = InboxMessagesView()
        self.view = view
    }
}

extension InboxMessagesViewController: InboxMessagesViewControllerProtocol {
    func displayMessages(viewModel: InboxMessages.LoadMessages.ViewModel) {
        
    }
}

