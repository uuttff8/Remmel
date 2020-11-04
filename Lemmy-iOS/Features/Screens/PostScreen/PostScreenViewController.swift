//
//  PostScreenViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenViewController: UIViewController {
    let postInfo: LemmyApiStructs.PostView

    lazy var customView = PostScreenUI(post: postInfo)
    lazy var model = PostScreenModel(post: postInfo)

    override func loadView() {
        self.view = customView
    }

    init(post: LemmyApiStructs.PostView) {
        self.postInfo = post

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        model.loadComments()
        model.commentsLoaded = { [self] (comments) in
            customView.commentsDataSource = comments
        }
        
        customView.presentOnVc = { toPresentVc in
            self.present(toPresentVc, animated: true)
        }
        
        customView.dismissOnVc = {
            self.dismiss(animated: true)
        }
    }
}
