//
//  PostScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenUI: UIView {
    private let postHeaderView = PostContentView()
    
    let postInfo: LemmyApiStructs.PostView
    
    init(post: LemmyApiStructs.PostView) {
        self.postInfo = post
        super.init(frame: .zero)
        
        createSubviews()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        // post header view
        postHeaderView.bind(with: postInfo)
        postHeaderView.setupUIForPost()
        
        self.addSubview(postHeaderView)
        
        self.postHeaderView.snp.makeConstraints { (make) in
            make.top.trailing.leading.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.systemBackground
    }
}
