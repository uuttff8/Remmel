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

protocol PostContentTableCellDelegate: AnyObject {
    func upvote(post: LemmyModel.PostView)
    func downvote(post: LemmyModel.PostView)
    func usernameTapped(in post: LemmyModel.PostView)
    func communityTapped(in post: LemmyModel.PostView)
}

class PostContentTableCell: UITableViewCell {
    
    var postContentView = PostContentView()
    let selBackView = UIView()
    
    func bind(with post: LemmyModel.PostView, config: PostContentView.Configuration) {
        self.contentView.addSubview(postContentView)

        self.postContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
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
                                published: Date.toLemmyDate(str: post.published).shortTimeAgoSinceNow,
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

    private let upvoteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(Config.Image.arrowUp, for: .normal)
        return btn
    }()

    private let downvoteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(Config.Image.arrowDown, for: .normal)
        return btn
    }()

    private let commentBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(Config.Image.comments, for: .normal)
        return btn
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 8
        return sv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addSubview(stackView)
        self.stackView.alignment = .leading

        [commentBtn, upvoteBtn, downvoteBtn].forEach { (btn) in
            btn.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5), imageTitlePadding: 5)
            btn.setTitleColor(UIColor.label, for: .normal)
            stackView.addArrangedSubview(btn)
        }
        self.stackView.addArrangedSubview(UIView())

        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
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
    private let imageSize = CGSize(width: 110, height: 60)

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        lbl.numberOfLines = 3
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lbl.numberOfLines = 6
        return lbl
    }()

    private let thumbailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .top
        stack.spacing = 8
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addSubview(subtitleLabel)
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func bind(with data: PostContentCenterView.ViewData) {
        titleLabel.text = data.title
        if let subtitle = data.subtitle, subtitle.count > 0 {
            subtitleLabel.text = subtitle
        }

        if let image = data.imageUrl {
            Nuke.loadImage(with: ImageRequest(url: URL(string: image)!), into: thumbailImageView)
            stackView.addArrangedSubview(thumbailImageView)

            thumbailImageView.snp.makeConstraints { (make) in
                make.size.equalTo(imageSize)
            }
        }

        layoutUI()
    }

    func setupUIForPost() {
        self.subtitleLabel.numberOfLines = 0
    }

    // MARK: - Private
    private func layoutUI() {
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
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

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
