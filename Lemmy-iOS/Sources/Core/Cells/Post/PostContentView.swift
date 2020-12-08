//
//  PostContentView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostContentView: UIView {
    
    enum Configuration {
        case `default`
        case fullPost
        case insideComminity
    }
    
    weak var delegate: PostContentTableCellDelegate?
    
    var configuration: Configuration = .default
    
    private let paddingView = UIView()
    private let headerView = PostContentHeaderView()
    private let centerView = PostContentCenterView()
    private let footerView = PostContentFooterView()
    private let separatorView = UIView.Configutations.separatorView
    
    init() {
        super.init(frame: .zero)
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with post: LemmyModel.PostView, config: Configuration) {
        self.configuration = config
        setupUI()
        setupTargets(with: post)
        
        headerView.bind(
            with: .init(
                avatarImageUrl: post.creatorAvatar,
                username: post.creatorName,
                community: post.communityName,
                published: post.published.require().shortTimeAgoSinceNow,
                urlDomain: post.getUrlDomain()
            )
        )
        
        centerView.bind(
            with: .init(
                imageUrl: post.thumbnailUrl,
                title: post.name,
                subtitle: post.body
            )
        )
        
        footerView.bind(
            with: .init(
                score: post.score,
                myVote: post.myVote,
                numberOfComments: post.numberOfComments,
                voteType: post.getVoteType()
            )
        )
        
    }
    
    private func setupTargets(with post: LemmyModel.PostView) {
        headerView.communityButtonTap = { [weak self] in
            self?.delegate?.communityTapped(in: post)
        }
        
        headerView.usernameButtonTap = { [weak self] in
            self?.delegate?.usernameTapped(in: post)
        }
        
        headerView.showMoreButtonTap = { [weak self] in
            self?.delegate?.showMore(in: post)
        }
        
        centerView.onLinkTap = { [weak self] (url) in
            self?.delegate?.onLinkTap(in: post, url: url)
        }
        
        footerView.downvoteButtonTap = { [weak self] (button, voteType) in
            self?.delegate?.downvote(voteButton: button, newVote: voteType, post: post)
        }
        
        footerView.upvoteButtonTap = { [weak self] (button, voteType) in
            self?.delegate?.upvote(voteButton: button, newVote: voteType, post: post)
        }
    }
    
    private func setupUI() {
        switch configuration {
        case .default: break
        case .insideComminity: setupUIForInsidePost()
        case .fullPost: setupUIForPost()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        separatorView.backgroundColor = Config.Color.separator
    }
    
    func prepareForReuse() {
        centerView.prepareForReuse()
        headerView.prepareForReuse()
    }
    
    private func setupUIForPost() {
        self.centerView.setupUIForPost()
    }
    
    private func setupUIForInsidePost() {
        self.headerView.setupUIForInsidePost()
    }
}

extension PostContentView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        // padding and separator
        self.addSubview(paddingView)
        self.addSubview(separatorView)
        
        paddingView.addSubview(headerView)
        paddingView.addSubview(centerView)
        paddingView.addSubview(footerView)
    }
    
    func makeConstraints() {
        paddingView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5) // SELF SIZE TOP HERE
            make.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
        }
                
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
                
        centerView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
                
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(centerView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // SELF SIZE BOTTOM HERE
        }

    }
}
