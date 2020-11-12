//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol PostScreenViewControllerProtocol: AnyObject {
    func displayPost(response: PostScreen.PostLoad.ViewModel)
}

class PostScreenViewController: UIViewController {
    
    weak var viewModel: PostScreenViewModelProtocol?
    
    lazy var customView = self.view as! PostScreenViewController.View

    override func loadView() {
        self.view = PostScreenViewController.View()
    }

    init(viewModel: PostScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.doPostFetch()
//        model.loadComments()
//        model.commentsLoaded = { [self] (comments) in
//            customView.commentsDataSource = comments
//        }
//
//        customView.presentOnVc = { toPresentVc in
//            self.present(toPresentVc, animated: true)
//        }
//
//        customView.dismissOnVc = {
//            self.dismiss(animated: true)
//        }
    }
}

extension PostScreenViewController: PostScreenViewControllerProtocol {
    func displayPost(response: PostScreen.PostLoad.ViewModel) {
        
    }
}
