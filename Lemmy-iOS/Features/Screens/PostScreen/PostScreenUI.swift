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
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        postHeaderView.bind(with: postInfo)
        postHeaderView.setupUIForPost()
        self.addSubview(postHeaderView)
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(500)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        self.postHeaderView.snp.makeConstraints { (make) in
            make.bottom.top.trailing.leading.equalToSuperview()
        }
    }
}
