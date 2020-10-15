//
//  CommentContentTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/13/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

protocol CommentContentTableCellDelegate: AnyObject {
    func usernameTapped(in comment: LemmyApiStructs.CommentView)
    func communityTapped(in comment: LemmyApiStructs.CommentView)
    func postNameTapped(in comment: LemmyApiStructs.CommentView)
    func upvote(comment: LemmyApiStructs.CommentView)
    func downvote(comment: LemmyApiStructs.CommentView)
    func showContext(in comment: LemmyApiStructs.CommentView)
    func reply(to comment: LemmyApiStructs.CommentView)
    func showMoreAction(in comment: LemmyApiStructs.CommentView)
}

class CommentContentTableCell: UITableViewCell {
    let commentContentView = CommentContentView()
    let selBackView = UIView()
    
    func bind(with comment: LemmyApiStructs.CommentView) {
        self.contentView.addSubview(commentContentView)
        
        self.commentContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        commentContentView.bind(with: comment)
        
        setupUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }
    
    func setupUI() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
    }
}

class CommentContentView: UIView {
    
    weak var delegate: CommentContentTableCellDelegate?
    
    private let paddingView = UIView()
    private let headerView = CommentHeaderView()
    private let centerView = CommentCenterView()
    private let footerView = CommentFooterView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Config.Color.separator
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
                published: Date.toLemmyDate(str: comment.published).toRelativeDate(),
                score: comment.score,
                postName: comment.postName
            )
        )
        
        centerView.bind(with:
            CommentCenterView.ViewData(
                comment: comment.content
            )
        )
        
        footerView.bind(with:
            CommentFooterView.ViewData(
                id: comment.id
            )
        )
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.separatorView.backgroundColor = Config.Color.separator
    }
    
    private func setupTargets(with comment: LemmyApiStructs.CommentView) {
        
        // header view
        headerView.communityButtonTap = { [weak self] in
            self?.delegate?.communityTapped(in: comment)
        }
        
        headerView.usernameButtonTap = { [weak self] in
            self?.delegate?.usernameTapped(in: comment)
        }
        
        headerView.postNameButtonTap = { [weak self] in
            self?.delegate?.postNameTapped(in: comment)
        }
        
        // footer view
        footerView.showContextTap = { [weak self] in
            self?.delegate?.showContext(in: comment)
        }
        
        footerView.upvoteTap = { [weak self] in
            self?.delegate?.upvote(comment: comment)
        }
        
        footerView.downvoteTap = { [weak self] in
            self?.delegate?.downvote(comment: comment)
        }
        
        footerView.replyTap = { [weak self] in
            self?.delegate?.reply(to: comment)
        }
        
        footerView.showMoreTap = { [weak self] in
            self?.delegate?.showMoreAction(in: comment)
        }
    }
    
    private func setupPaddingAndSeparatorUI() {
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
    }
    
    private func setupUI() {
        setupPaddingAndSeparatorUI()
        
        // header view
        paddingView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        // center view
        paddingView.addSubview(centerView)
        
        centerView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.trailing.leading.equalToSuperview()
        }
        
        // footer view
        paddingView.addSubview(footerView)
        
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(centerView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview() // SELF SIZE BOTTOM HERE
        }
    }
}

private class CommentHeaderView: UIView {
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?
    var postNameButtonTap: (() -> Void)?
    
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
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.numberOfLines = 0
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
        setupButtonTargets()
    }
    
    private func setupViews(_ comment: CommentHeaderView.ViewData) {
        
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
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupButtonTargets() {
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped(sender:)), for: .touchUpInside)
        communityButton.addTarget(self, action: #selector(communityButtonTapped(sender:)), for: .touchUpInside)
        postNameButton.addTarget(self, action: #selector(postNameButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func communityButtonTapped(sender: UIButton!) {
        communityButtonTap?()
    }
    
    @objc private func usernameButtonTapped(sender: UIButton!) {
        usernameButtonTap?()
    }
    
    @objc private func postNameButtonTapped(sender: UIButton!) {
        postNameButtonTap?()
    }
}

private class CommentCenterView: UIView {
    
    struct ViewData {
        let comment: String
    }
    
    private let commentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with data: CommentCenterView.ViewData) {
        commentLabel.text = data.comment
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(commentLabel)
        
        commentLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}

// MARK: - Footer -
private class CommentFooterView: UIView {
    var showContextTap: (() -> Void)?
    var upvoteTap: (() -> Void)?
    var downvoteTap: (() -> Void)?
    var replyTap: (() -> Void)?
    var showMoreTap: (() -> Void)?
    
    // MARK: - Constants
    private let iconSize = CGSize(width: 20, height: 20)
    
    // MARK: - Data
    struct ViewData {
        let id: Int
    }
    
    // MARK: - UI Elements
    private let showContextButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "link")?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let upvoteButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "arrow.up")?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
        return btn
        
    }()
    
    private let downvoteButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "arrow.down")?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let replyButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "arrowshape.turn.up.left.fill")?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let showMoreButton: UIButton = {
        let btn = UIButton()
        
        let image = UIImage(systemName: "ellipsis")?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        
        btn.setImage(image, for: .normal)
        return btn
    }()
    
    private let stackView = UIStackView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with: CommentFooterView.ViewData) {
        setupUI()
        setupTargets()
    }
    
    private func setupTargets() {
        showContextButton.addTarget(self, action: #selector(showContextButtonTapped(sender:)), for: .touchUpInside)
        upvoteButton.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonTapped(sender:)), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(sender:)), for: .touchUpInside)
    }
    
    func setupUI() {
        
        // settup up stack view
        self.addSubview(stackView)
        self.stackView.alignment = .center
        stackView.spacing = 40
        
        // constraints
        stackView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        [showContextButton, upvoteButton, downvoteButton, replyButton, showMoreButton].forEach { (btn) in
            self.stackView.addArrangedSubview(btn)
            
            btn.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
        }
        
        self.stackView.addArrangedSubview(UIView())
    }
    
    @objc private func showContextButtonTapped(sender: UIButton!) {
        showContextTap?()
    }
    
    @objc private func upvoteButtonTapped(sender: UIButton!) {
        upvoteTap?()
    }

    @objc private func downvoteButtonTapped(sender: UIButton!) {
        downvoteTap?()
    }

    @objc private func replyButtonTapped(sender: UIButton!) {
        replyTap?()
    }

    @objc private func showMoreButtonTapped(sender: UIButton!) {
        showMoreTap?()
    }
    
    // MARK: - Content Size
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
