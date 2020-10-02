//
//  PostContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

protocol PostContentTableCellDelegate: AnyObject {
    func upvote(post: LemmyApiStructs.PostView)
    func downvote(post: LemmyApiStructs.PostView)
    func usernameTapped(in post: LemmyApiStructs.PostView)
    func communityTapped(in post: LemmyApiStructs.PostView)
}

class PostContentTableCell: UITableViewCell {
    
    let postContentView = PostContentView()
    
    func bind(with post: LemmyApiStructs.PostView) {
        self.contentView.addSubview(postContentView)
        
        self.postContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        postContentView.bind(with: post)
        
        setupUI()
    }
    
    func setupUI() {
        let selBackView = UIView()
        selBackView.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        self.selectedBackgroundView = selBackView
    }
}

class PostContentView: UIView {
    
    weak var delegate: PostContentTableCellDelegate?
    
    private let paddingView = UIView()
    private let headerView = PostContentHeaderView()
    private let centerView = PostContentCenterView()
    private let footerView = PostContentFooterView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        return view
    }()
    
    func bind(with post: LemmyApiStructs.PostView) {
        setupUI()
        setupTargets(with: post)
        
        headerView.bind(with:
            PostContentHeaderView.ViewData(
                avatarImageUrl: post.creatorAvatar,
                username: post.creatorName,
                community: post.communityName,
                published: Date.toLemmyDate(str: post.published).toRelativeDate()
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
    
    private func setupTargets(with post: LemmyApiStructs.PostView) {
        headerView.communityButtonTap = { [weak self] in
            self?.delegate?.communityTapped(in: post)
        }
        
        headerView.usernameButtonTap = { [weak self] in
            self?.delegate?.usernameTapped(in: post)
        }
        
        footerView.downvoteButtonTap = { [weak self] in
            self?.delegate?.downvote(post: post)
        }
        
        footerView.upvoteButtonTap = { [weak self] in
            self?.delegate?.upvote(post: post)
        }
    }
    
    private func setupUI() {
        
        // padding and separator
        self.addSubview(paddingView)
        self.addSubview(separatorView)
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
    
    func setupUIForPost() {
        self.centerView.setupUIForPost()
    }
}

private class PostContentFooterView: UIView {
    var upvoteButtonTap: (() -> Void)?
    var downvoteButtonTap: (() -> Void)?
    
    private let iconSize = CGSize(width: 20, height: 20)
    
    struct ViewData {
        let upvote: Int
        let downvote: Int
        let numberOfComments: Int
    }
    
    private let upvoteBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "arrow.up")?
            .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let downvoteBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "arrow.down")?
            .withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
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
        upvoteBtn.setTitle(String(data.upvote), for: .normal)
        downvoteBtn.setTitle(String(data.downvote), for: .normal)
        commentBtn.setTitle(String(data.numberOfComments), for: .normal)

        self.addSubview(stackView)
        self.stackView.alignment = .center
        stackView.spacing = 8
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
                
        [commentBtn, upvoteBtn, downvoteBtn].forEach { (btn) in
            self.stackView.addArrangedSubview(btn)
            btn.setTitleColor(UIColor.label, for: .normal)
            btn.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5), imageTitlePadding: 5)
            
            btn.snp.makeConstraints { (make) in
                make.height.equalTo(30).labeled("BUTTONS_COMMENT_UPVOTE")
            }
        }
        self.stackView.addArrangedSubview(UIView())
        
        
        upvoteBtn.setTitle(String(data.upvote), for: .normal)
        downvoteBtn.setTitle(String(data.downvote), for: .normal)
        commentBtn.setTitle(String(data.numberOfComments), for: .normal)
        
        setupButtonTaps()
    }
    
    func setupButtonTaps() {
        downvoteBtn.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        upvoteBtn.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func upvoteButtonTapped(sender: UIButton!) {
        upvoteButtonTap?()
    }
    
    @objc private func downvoteButtonTapped(sender: UIButton!) {
        downvoteButtonTap?()
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
    
    func setupUIForPost() {
        self.subtitleLabel.numberOfLines = 0
    }
    
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

private class PostContentHeaderView: UIView {
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?
    
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
    let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    let communityButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    let publishedTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    let toTitle: UILabel = {
        let title = UILabel()
        title.text = "to"
        title.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
        let usernameButtonText = "@" + data.username
        
        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(data.community, for: .normal)
        publishedTitle.text = data.published
        
        setupViews(data)        
        
        self.addSubview(stackView)
        
        self.stackView.alignment = .center
        self.stackView.spacing = 8
        stackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
        }        
        
        setupTargets()
    }
    
    private func setupTargets() {
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(sender:)), for: .touchUpInside)
        communityButton.addTarget(self, action: #selector(communityButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func usernameButtonTapped(sender: UIButton!) {
        usernameButtonTap?()
    }
    
    @objc private func communityButtonTapped(sender: UIButton!) {
        communityButtonTap?()
    }
    
    private func setupViews(_ data: PostContentHeaderView.ViewData) {
        [usernameButton, toTitle, communityButton, publishedTitle].forEach { (label) in
            self.stackView.addArrangedSubview(label)
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
