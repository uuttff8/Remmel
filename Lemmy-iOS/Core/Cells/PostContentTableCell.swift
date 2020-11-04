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
    
    enum Configuration {
        case `default`
        case post
        case insideComminity
    }
    
    let postContentView = PostContentView()
    let selBackView = UIView()
    var configuration: Configuration?
    
    func bind(with post: LemmyApiStructs.PostView, config: Configuration) {
        self.configuration = config
        self.contentView.addSubview(postContentView)

        self.postContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        postContentView.bind(with: post)

        setupUI()
    }

    func setupUI() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
        
        switch configuration {
        case .default: break
        case .insideComminity:
            postContentView.setupUIForInsidePost()
        case .post: postContentView.setupUIForPost()
        case .none: break
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
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
        view.backgroundColor = Config.Color.separator
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
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        separatorView.backgroundColor = Config.Color.separator
    }

    func setupUIForPost() {
        self.centerView.setupUIForPost()
    }
    
    func setupUIForInsidePost() {
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
    }

    // MARK: - Properties
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?

    private let imageSize = CGSize(width: 32, height: 32)

    private lazy var avatarView: UIImageView = {
        let ava = UIImageView()
        ava.layer.cornerRadius = imageSize.width / 2
        ava.layer.masksToBounds = false
        ava.clipsToBounds = true
        return ava
    }()

    private let usernameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()

    private let communityButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()

    private let publishedTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()

    private let toTitle: UILabel = {
        let title = UILabel()
        title.text = "to"
        title.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return title
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addSubview(stackView)

        [usernameButton, toTitle, communityButton, publishedTitle].forEach { (label) in
            self.stackView.addArrangedSubview(label)
        }

        stackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
        }

        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func bind(with data: PostContentHeaderView.ViewData) {
        let usernameButtonText = "@" + data.username

        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(data.community, for: .normal)
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
        Nuke.loadImage(with: ImageRequest(url: URL(string: url)!), into: avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize.height)
        }
        self.stackView.insertArrangedSubview(avatarView, at: 0)
    }
    
    func setupUIForInsidePost() {
        toTitle.isHidden = true
        communityButton.isHidden = true
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
