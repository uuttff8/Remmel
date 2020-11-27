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
    func upvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView)
    func downvote(voteButton: VoteButton, newVote: LemmyVoteType, post: LemmyModel.PostView)
    func usernameTapped(in post: LemmyModel.PostView)
    func communityTapped(in post: LemmyModel.PostView)
    func onLinkTap(in post: LemmyModel.PostView, url: URL)
}

class PostContentTableCell: UITableViewCell {
    
    var postContentView = PostContentView()
    let selBackView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with post: LemmyModel.PostView, config: PostContentView.Configuration) {
        postContentView.bind(with: post, config: config)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }
    
    override func prepareForReuse() {
        postContentView.prepareForReuse()
    }
}

extension PostContentTableCell: ProgrammaticallyViewProtocol {
    func setupView() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
    }
    
    func addSubviews() {
        self.contentView.addSubview(postContentView)
    }
    
    func makeConstraints() {
        self.postContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
        
        // padding and separator
        self.addSubview(paddingView)
        self.addSubview(separatorView)
        paddingView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5) // SELF SIZE TOP HERE
            make.leading.equalToSuperview().offset(16)
            make.bottom.leading.trailing.equalToSuperview().inset(16)
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
        headerView.prepareForReuse()
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
        let score: Int
        let myVote: Int?
        let numberOfComments: Int
        var voteType: LemmyVoteType
    }
    
    // MARK: - Properties
    var upvoteButtonTap: ((VoteButton, LemmyVoteType) -> Void)?
    var downvoteButtonTap: ((VoteButton, LemmyVoteType) -> Void)?
    
    private let iconSize = CGSize(width: 20, height: 20)
    
    private let upvoteBtn = VoteButton(voteType: .top).then {
        $0.setImage(Config.Image.arrowUp, for: .normal)
    }
    
    private let downvoteBtn = VoteButton(voteType: .down).then {
        $0.setImage(Config.Image.arrowDown, for: .normal)
    }
    
    let scoreLabel = UILabel()
    
    private let commentBtn = UIButton().then {
        $0.setImage(Config.Image.comments, for: .normal)
        $0.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5),
                     imageTitlePadding: 5)
        $0.setTitleColor(.label, for: .normal)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .leading
    }
    
    private var viewData: ViewData?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(stackView)
        
        stackView.addStackViewItems(
            .view(upvoteBtn),
            .view(scoreLabel),
            .view(downvoteBtn),
            .view(UIView()),
            .view(commentBtn)
        )
        
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
        self.viewData = data
        
        scoreLabel.text = String(data.score)
        upvoteBtn.scoreValue = data.voteType
        downvoteBtn.scoreValue = data.voteType
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
    
    @objc private func upvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            let type = viewData.voteType == .up ? .none : LemmyVoteType.up
            self.viewData?.voteType = type
            
            downvoteBtn.scoreValue = .none
            upvoteBtn.setVoted(to: type)
            upvoteButtonTap?(sender, type)
        }
    }
    
    @objc private func downvoteButtonTapped(sender: VoteButton!) {
        if let viewData = viewData {
            let type = viewData.voteType == .down ? .none : LemmyVoteType.down
            self.viewData?.voteType = type
            
            upvoteBtn.scoreValue = .none
            downvoteBtn.setVoted(to: type)
            downvoteButtonTap?(sender, type)
        }
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
        $0.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        $0.numberOfLines = 3
    }
    
    private lazy var subtitleLabel = NantesLabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        thumbailImageView.isHidden = false
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
