//
//  PostScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostScreenUI: UIView {
    
    let tableView = UITableView()
        
    let postInfo: LemmyApiStructs.PostView
    
    init(post: LemmyApiStructs.PostView) {
        self.postInfo = post
        super.init(frame: .zero)
        
        self.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.tableView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

private class PostScreenUITableCell: UITableViewCell {
    private let postHeaderView = PostContentView()
    private lazy var postGreenOutlineView = LemmyGreenOutlinePostEmbed(
        with:
            LemmyGreenOutlinePostEmbed.Data(
                title: postInfo.embedTitle,
                description: postInfo.embedDescription
            )
    )
    
    let postInfo: LemmyApiStructs.PostView
    
    init(post: LemmyApiStructs.PostView) {
        self.postInfo = post
        super.init(style: .default, reuseIdentifier: nil)
        
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
        self.addSubview(postGreenOutlineView)
        
        
        self.postHeaderView.snp.makeConstraints { (make) in
            make.top.trailing.leading.equalToSuperview()
        }
        
        self.postGreenOutlineView.snp.makeConstraints { (make) in
            make.top.equalTo(postHeaderView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.systemBackground
    }
}

extension PostScreenUI: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostScreenUITableCell(post: postInfo)
        return cell
    }
}
