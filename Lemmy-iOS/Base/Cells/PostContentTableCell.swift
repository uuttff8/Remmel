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
    
    private let paddingView = UIView()
    private let headerView = PostContentHeaderView()
    private let centerView = PostContentCenterView()
    private let footerView = PostContentFooterView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(with post: LemmyApiStructs.PostView) {
        setupUI()
        
        headerView.bind(with:
            PostContentHeaderView.ViewData(
                avatarImageUrl: post.creatorAvatar,
                username: post.creatorName,
                community: post.communityName,
                published: post.published
            )
        )
        
        centerView.bind(with:
            PostContentCenterView.ViewData(
                imageUrl: post.thumbnailUrl,
                title: post.name,
                subtitle: post.body
            )
        )
        
        footerView.bind(with:
            PostContentFooterView.ViewData(
                upvote: post.upvotes,
                downvote: post.downvotes,
                numberOfComments: post.numberOfComments
            )
        )
        
    }
    
    
    private func setupUI() {
        
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
        
        // header view
        paddingView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        // center view
        paddingView.addSubview(centerView)
        
        centerView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        // footer view
        paddingView.addSubview(footerView)
        
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(centerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // SELF SIZE BOTTOM HERE
        }
        
    }
}

private class PostContentFooterView: UIView {
    private let iconSize = CGSize(width: 20, height: 20)
    
    struct ViewData {
        let upvote: Int
        let downvote: Int
        let numberOfComments: Int
    }
    
    private let upvoteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "arrow-20"), for: .normal)
        return btn
    }()
    
    private let downvoteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "arrow-20"), for: .normal)
        return btn
    }()
    
    private let commentBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "comments"), for: .normal)
        return btn
    }()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: PostContentFooterView.ViewData) {
        self.addSubview(stackView)
        self.stackView.alignment = .center
        stackView.spacing = 8
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        upvoteBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        downvoteBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi * 0.5)

        upvoteBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        downvoteBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        commentBtn.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        [commentBtn, upvoteBtn, downvoteBtn].forEach { (btn) in
            self.stackView.addArrangedSubview(btn)
            btn.setTitleColor(UIColor.label, for: .normal)
            btn.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5), imageTitlePadding: 5)
        }
        self.stackView.addArrangedSubview(UIView())
        
        
        upvoteBtn.setTitle(String(data.upvote), for: .normal)
        downvoteBtn.setTitle(String(data.downvote), for: .normal)
        commentBtn.setTitle(String(data.numberOfComments), for: .normal)

    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
}

private class PostContentCenterView: UIView {
    private let imageSize = CGSize(width: 110, height: 60)
    
    struct ViewData {
        let imageUrl: String?
        let title: String
        let subtitle: String?
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lbl.numberOfLines = 6
        return lbl
    }()
    
    private lazy var thumbailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: PostContentCenterView.ViewData) {
        titleLabel.text = data.title
        if let subtitle = data.subtitle, subtitle.count > 0 {
            subtitleLabel.text = subtitle
        }
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        
        if let image = data.imageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: image)!), into: thumbailImageView)
            stackView.addArrangedSubview(thumbailImageView)
            thumbailImageView.snp.makeConstraints { (make) in
                make.size.equalTo(imageSize)
            }
        }
        
        self.stackView.alignment = .center
        self.stackView.spacing = 8
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

private class PostContentHeaderView: UIView {
    private let imageSize = CGSize(width: 32, height: 32)
    
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
    }
    
    lazy var avatarView: UIImageView = {
        let ava = UIImageView()
        ava.layer.cornerRadius = imageSize.width / 2
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
    
    func bind(with data: PostContentHeaderView.ViewData) {
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
    
    private func setupViews(_ data: PostContentHeaderView.ViewData) {
        [usernameTitle, toTitle, communityTitle, publishedTitle].forEach { (label) in
            self.stackView.addArrangedSubview(label)
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        if let avatarUrl = data.avatarImageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: avatarUrl)!), into: avatarView)
            avatarView.snp.makeConstraints { (make) in
                make.size.equalTo(imageSize.height)
            }
            self.stackView.insertArrangedSubview(avatarView, at: 0)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
