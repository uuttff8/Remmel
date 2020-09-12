//
//  PostContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class PostContentTableCell: UITableViewCell {
    
    private var paddingView = UIView()
    private var headerView = PostContentHeaderInfoView()
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentView.addSubview(paddingView)
        self.contentView.addSubview(separatorView)
        paddingView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.trailing.equalToSuperview().inset(10)
            make.height.equalTo(100)
        }
        separatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        let selBackView = UIView()
        selBackView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        self.selectedBackgroundView = selBackView
        
    }
    
    func bind(with post: LemmyApiStructs.PostView) {
        
        headerView.bind(with:
            PostContentHeaderInfoView.ViewData(
                avatarImageUrl: post.creatorAvatar,
                username: post.creatorName,
                community: post.communityName,
                published: post.published
            )
        )
        
        paddingView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
}

private class PostContentHeaderInfoView: UIView {
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
    }
    
    lazy var avatarView: UIImageView = {
        let ava = UIImageView()
        ava.layer.cornerRadius = 32 / 2
        ava.layer.masksToBounds = false
        ava.clipsToBounds = true
        return ava
    }()
    let usernameTitle: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1)
        return title
    }()
    let communityTitle: UILabel = {
        let title = UILabel()
        title.textColor = UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1)
        return title
    }()
    let publishedTitle = UILabel()
    let toTitle: UILabel = {
        let title = UILabel()
        title.text = "to"
        title.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        return title
    }()
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: PostContentHeaderInfoView.ViewData) {
        usernameTitle.text = data.username
        usernameTitle.text = "@" + usernameTitle.text!
        communityTitle.text = data.community
        publishedTitle.text = data.published
        
        setupViews(data)
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        
        self.addSubview(stackView)
        
        self.stackView.alignment = .center
        self.stackView.spacing = 8
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
        }
        
        publishedTitle.snp.makeConstraints { (make) in
            make.width.equalTo(60)
        }
    }
    
    private func setupViews(_ data: PostContentHeaderInfoView.ViewData) {
        [usernameTitle, toTitle, communityTitle, publishedTitle].forEach { (label) in
            self.stackView.addArrangedSubview(label)
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        if let avatarUrl = data.avatarImageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: avatarUrl)!), into: avatarView)
            avatarView.snp.makeConstraints { (make) in
                make.size.equalTo(32)
            }
            self.stackView.insertArrangedSubview(avatarView, at: 0)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
