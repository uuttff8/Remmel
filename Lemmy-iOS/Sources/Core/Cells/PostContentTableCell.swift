//
//  PostContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke
import DateToolsSwift
import SwiftyMarkdown
import Nantes

protocol PostContentTableCellDelegate: AnyObject {
    func upvote(post: LemmyModel.PostView)
    func downvote(post: LemmyModel.PostView)
    func usernameTapped(in post: LemmyModel.PostView)
    func communityTapped(in post: LemmyModel.PostView)
    func onLinkTap(in post: LemmyModel.PostView, url: URL)
}

class PostContentTableCell: UITableViewCell {
    
    var postContentView = PostContentView()
    let selBackView = UIView()
    
    func bind(with post: LemmyModel.PostView, config: PostContentView.Configuration) {
        self.contentView.addSubview(postContentView)

        self.postContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        postContentView.bind(with: post, config: config)

        setupUI()
    }

    func setupUI() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }
    
    override func prepareForReuse() {
        postContentView.prepareForReuse()
    }
}

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

    func bind(with post: LemmyModel.PostView, config: Configuration) {
        self.configuration = config
        setupUI()
        setupTargets(with: post)

        headerView.bind(with:
                            PostContentHeaderView.ViewData(
                                avatarImageUrl: post.creatorAvatar,
                                username: post.creatorName,
                                community: post.communityName,
                                published: post.published.require().shortTimeAgoSinceNow,
                                urlDomain: post.getUrlDomain()
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

    private func setupTargets(with post: LemmyModel.PostView) {
        headerView.communityButtonTap = { [weak self] in
            self?.delegate?.communityTapped(in: post)
        }

        headerView.usernameButtonTap = { [weak self] in
            self?.delegate?.usernameTapped(in: post)
        }

        centerView.onLinkTap = { [weak self] (url) in
            self?.delegate?.onLinkTap(in: post, url: url)
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
            make.top.leading.equalToSuperview().offset(16) // SELF SIZE TOP HERE
            make.bottom.trailing.equalToSuperview().inset(16)
        }
        separatorView.snp.makeConstraints { (make) in
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
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }

        // footer view
        paddingView.addSubview(footerView)

        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(centerView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // SELF SIZE BOTTOM HERE
        }
        
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
    }

    private func setupUIForPost() {
        self.centerView.setupUIForPost()
    }
    
    private func setupUIForInsidePost() {
        self.headerView.setupUIForInsidePost()
    }
}

// MARK: -
private class PostContentFooterView: UIView {
    struct ViewData {
        let upvote: Int
        let downvote: Int
        let numberOfComments: Int
    }

    // MARK: - Properties
    var upvoteButtonTap: (() -> Void)?
    var downvoteButtonTap: (() -> Void)?

    private let iconSize = CGSize(width: 20, height: 20)

    private let upvoteBtn = UIButton().then {
        $0.setImage(Config.Image.arrowUp, for: .normal)
    }

    private let downvoteBtn = UIButton().then {
        $0.setImage(Config.Image.arrowDown, for: .normal)
    }

    private let commentBtn = UIButton().then {
        $0.setImage(Config.Image.comments, for: .normal)
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .leading
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addSubview(stackView)
        
        stackView.addStackViewItems(
            .view(commentBtn),
            .view(upvoteBtn),
            .view(downvoteBtn),
            .view(UIView())
        )
        
        [commentBtn, upvoteBtn, downvoteBtn].forEach { (btn) in
            btn.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5),
                          imageTitlePadding: 5)
            btn.setTitleColor(.label, for: .normal)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind
    func bind(with data: PostContentFooterView.ViewData) {
        upvoteBtn.setTitle(String(data.upvote), for: .normal)
        downvoteBtn.setTitle(String(data.downvote), for: .normal)
        commentBtn.setTitle(String(data.numberOfComments), for: .normal)
    }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        upvoteBtn.setImage(Config.Image.arrowUp, for: .normal)
        downvoteBtn.setImage(Config.Image.arrowDown, for: .normal)
        commentBtn.setImage(Config.Image.comments, for: .normal)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }

    // MARK: - Private
    private func setupTargets() {
        downvoteBtn.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        upvoteBtn.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc private func upvoteButtonTapped(sender: UIButton!) {
        upvoteButtonTap?()
    }

    @objc private func downvoteButtonTapped(sender: UIButton!) {
        downvoteButtonTap?()
    }
}

// MARK: -
private class PostContentCenterView: UIView {

    // MARK: - Data
    struct ViewData {
        let imageUrl: String?
        let title: String
        let subtitle: String?
    }

    // MARK: - Properties
    var onLinkTap: ((URL) -> Void)?
    
    private let imageSize = CGSize(width: 110, height: 60)

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        $0.numberOfLines = 3
    }
    
    private lazy var subtitleLabel = NantesLabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.delegate = self
        $0.numberOfLines = 6
    }

    private let thumbailImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }

    private let titleImageStackView = UIStackView().then {
        $0.alignment = .top
        $0.spacing = 8
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(mainStackView)
        
        titleImageStackView.addStackViewItems(
            .view(titleLabel),
            .view(thumbailImageView)
        )
        
        mainStackView.addStackViewItems(
            .view(titleImageStackView),
            .view(subtitleLabel)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func bind(with data: PostContentCenterView.ViewData) {
        titleLabel.text = data.title
        
        if let subtitle = data.subtitle {
            let md = SwiftyMarkdown(string: subtitle)
            md.link.color = .systemBlue
            subtitleLabel.attributedText = md.attributedString()
            
            subtitleLabel.linkAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        }

        if let image = data.imageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: image)!), into: thumbailImageView)
        } else {
            thumbailImageView.isHidden = true
        }

        layoutUI()
    }
    
    func setupUIForPost() {
        self.subtitleLabel.numberOfLines = 0
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        thumbailImageView.image = nil
    }

    // MARK: - Private
    private func layoutUI() {
        thumbailImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize)
        }
        
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

extension PostContentCenterView: NantesLabelDelegate {
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        onLinkTap?(link)
    }
}

// MARK: -
private class PostContentHeaderView: UIView {

    // MARK: - Data
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
        let urlDomain: String?
    }

    // MARK: - Properties
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?

    private let imageSize = CGSize(width: 32, height: 32)

    lazy var avatarImageView = UIImageView().then {
        $0.layer.cornerRadius = imageSize.width / 2
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }
    
    private let usernameButton = ResizableButton().then {
        $0.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let communityButton = ResizableButton().then {
        $0.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    private let publishedTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    private let byTitle = UILabel().then {
        $0.text = "by"
        $0.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    private let dotTitle = UILabel().then {
        $0.text = " · "
        $0.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    lazy var urlDomainTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    private let userCommunityStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 2
    }
    
    private let mainStackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 8
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(mainStackView)
        
        bottomStackView.addStackViewItems(
            .view(byTitle),
            .view(usernameButton),
            .view(dotTitle),
            .view(publishedTitle)
        )
        
        userCommunityStackView.addStackViewItems(
            .view(communityButton),
            .view(bottomStackView)
        )
        
        mainStackView.addStackViewItems(
            .view(avatarImageView),
            .view(userCommunityStackView)
        )
        
        mainStackView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }

        setupTargets()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func bind(with data: PostContentHeaderView.ViewData) {
        let usernameButtonText = "@" + data.username
        let communityButtonText = "!" + data.community

        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(communityButtonText, for: .normal)
        publishedTitle.text = data.published
        
        if let avatarUrl = data.avatarImageUrl {
            setupAvatar(with: avatarUrl)
        } else {
            avatarImageView.isHidden = true
        }
    }

    // MARK: - Private
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

    private func setupAvatar(with url: String) {
        Nuke.loadImage(with: ImageRequest(url: URL(string: url)!), into: avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize.height)
        }
        self.mainStackView.insertArrangedSubview(avatarImageView, at: 0)
    }
    
    func setupUIForInsidePost() {
        byTitle.isHidden = true
        communityButton.isHidden = true
    }
    
    func setupUIForPost() {
        
    }
    
    func prepareForReuse() {
        publishedTitle.text = nil
        urlDomainTitle.text = nil
        avatarImageView.image = nil
        usernameButton.setTitle(nil, for: .normal)
        communityButton.setTitle(nil, for: .normal)
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
