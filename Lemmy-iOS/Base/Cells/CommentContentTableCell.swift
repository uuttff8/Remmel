//
//  CommentContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class CommentContentTableCell: UITableViewCell {
    
    private let paddingView = UIView()
    private let headerView = CommentHeaderView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        return view
    }()
    
    func bind(with comment: LemmyApiStructs.CommentView) {
        setupUI()
        setupTargets(with: comment)
        
        headerView.bind(with:
            CommentHeaderView.ViewData(
                avatarImageUrl: comment.creatorAvatar,
                username: comment.creatorName,
                community: comment.communityName,
                published: comment.published,
                score: comment.score,
                postName: comment.postName
            )
        )
        
    }
    
    private func setupTargets(with comment: LemmyApiStructs.CommentView) {
    }
    
    private func setupPaddingAndSeparatorUI() {
        // padding and separator
        self.contentView.addSubview(paddingView)
        self.contentView.addSubview(separatorView)
        paddingView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10) // SELF SIZE TOP HERE
            make.bottom.trailing.equalToSuperview().inset(10)
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
    
    private func setupUI() {
        setupPaddingAndSeparatorUI()
        
        // header view
        paddingView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // SELF SIZE BOTTOM HERE
        }
    }
}

private class CommentHeaderView: UIView {
    private let imageSize = CGSize(width: 32, height: 32)
    
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
        let score: Int
        let postName: String
    }
    
    lazy var avatarView: UIImageView = {
        let ava = UIImageView()
        ava.layer.cornerRadius = imageSize.width / 2
        ava.layer.masksToBounds = false
        ava.clipsToBounds = true
        return ava
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    let toTitle: UILabel = {
        let title = UILabel()
        title.text = "to"
        title.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return title
    }()
    
    let communityButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    let scoreLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    let publishedTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    let postNameButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        return btn
    }()
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with comment: CommentHeaderView.ViewData) {
        let usernameButtonText = "@" + comment.username
        
        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(comment.community, for: .normal)
        publishedTitle.text = comment.published
        scoreLabel.set(text: String(comment.score), leftIcon: UIImage(systemName: "bolt.fill")!)
        postNameButton.setTitle(comment.postName, for: .normal)
        
        setupViews(comment)
        
    }
    
    private func setupViews(_ comment: CommentHeaderView.ViewData) {
        publishedTitle.snp.makeConstraints { (make) in
            make.width.equalTo(60)
        }
        
        [usernameButton, toTitle, communityButton, scoreLabel, publishedTitle].forEach { (label) in
            stackView.addArrangedSubview(label)
        }
        if let avatarUrl = comment.avatarImageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: avatarUrl)!), into: avatarView)
            avatarView.snp.makeConstraints { (make) in
                make.size.equalTo(imageSize.height)
            }
            
            stackView.insertArrangedSubview(avatarView, at: 0)
        }
        
        self.addSubview(stackView)
        self.addSubview(postNameButton)
        
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
        }
        
        self.postNameButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.bottom.equalToSuperview()
        }
    }
}
