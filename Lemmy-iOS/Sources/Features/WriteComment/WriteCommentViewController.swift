//
//  WriteCommentViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol WriteCommentViewControllerProtocol: AnyObject {
    func displayWriteCommentForm()
}

class WriteCommentViewController: UIViewController {
    
    private let viewModel: WriteCommentViewModelProtocol
    
    init(viewModel: WriteCommentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WriteCommentViewController: WriteCommentViewControllerProtocol {
    func displayWriteCommentForm() {
        
    }
}
