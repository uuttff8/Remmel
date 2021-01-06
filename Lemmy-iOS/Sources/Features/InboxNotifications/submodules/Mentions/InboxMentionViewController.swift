//
//  InboxMentionViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxMentionsViewControllerProtocol: AnyObject {
    func displayMentions(viewModel: InboxMentions.LoadMentions.ViewModel)
}

final class InboxMentionsViewController: UIViewController {
    
    private let viewModel: InboxMentionsViewModel
    
    init(
        viewModel: InboxMentionsViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = InboxMentionsView()
        self.view = view
    }
}

extension InboxMentionsViewController: InboxMentionsViewControllerProtocol {
    func displayMentions(viewModel: InboxMentions.LoadMentions.ViewModel) {
        
    }
}
