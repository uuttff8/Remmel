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
    func usernameTapped(in comment: LemmyModel.CommentView)
    func communityTapped(in comment: LemmyModel.CommentView)
    func postNameTapped(in comment: LemmyModel.CommentView)
    func upvote(comment: LemmyModel.CommentView)
    func downvote(comment: LemmyModel.CommentView)
    func showContext(in comment: LemmyModel.CommentView)
    func reply(to comment: LemmyModel.CommentView)
    func showMoreAction(in comment: LemmyModel.CommentView)
}

// MARK: -
class CommentContentTableCell: UITableViewCell {

    // MARK: - Properties
    let commentContentView = CommentContentView()
    let selBackView = UIView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()

        self.contentView.addSubview(commentContentView)

        self.commentContentView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: LemmyModel.CommentView) {
        commentContentView.bind(with: comment)
    }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        selBackView.backgroundColor = Config.Color.highlightCell
    }

    // MARK: - Private API
    private func setupUI() {
        selBackView.backgroundColor = Config.Color.highlightCell
        self.selectedBackgroundView = selBackView
    }
}

// MARK: -
class CommentContentView: UIView {

    // MARK: - Properties
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

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: LemmyModel.CommentView) {
        setupTargets(with: comment)

        headerView.bind(with:
            CommentHeaderView.ViewData(
                avatarImageUrl: comment.creatorAvatar,
                username: comment.creatorName,
                community: comment.communityName,
                published: comment.published.shortTimeAgoSinceNow,
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

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.separatorView.backgroundColor = Config.Color.separator
    }

    // MARK: - Private
    private func setupTargets(with comment: LemmyModel.CommentView) {

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

    private func setupPaddingAndSeparatorUI() {
        // padding and separator
        self.addSubview(paddingView)
        self.addSubview(separatorView)
        paddingView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(16) // SELF SIZE TOP HERE
            make.bottom.trailing.equalToSuperview().inset(16)
        }
        separatorView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
        }
    }
}

// MARK: -
private class CommentHeaderView: UIView {

    // MARK: - ViewData
    struct ViewData {
        let avatarImageUrl: String?
        let username: String
        let community: String
        let published: String
        let score: Int
        let postName: String
    }

    // MARK: - Properties
    var communityButtonTap: (() -> Void)?
    var usernameButtonTap: (() -> Void)?
    var postNameButtonTap: (() -> Void)?

    private let imageSize = CGSize(width: 32, height: 32)

    lazy var avatarView = UIImageView().then {
        $0.layer.cornerRadius = imageSize.width / 2
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
    }

    let usernameButton = UIButton().then {
        $0.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let toTitle = UILabel().then {
        $0.text = "to"
        $0.textColor = UIColor(red: 108/255, green: 117/255, blue: 125/255, alpha: 1)
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    let communityButton = UIButton().then {
        $0.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let scoreLabel = UILabel()

    let publishedTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    let postNameButton = UIButton().then {
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.setTitleColor(UIColor(red: 241/255, green: 100/255, blue: 30/255, alpha: 1), for: .normal)
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.numberOfLines = 0

    }

    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 8
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupButtonTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with comment: CommentHeaderView.ViewData) {
        let usernameButtonText = "@" + comment.username

        usernameButton.setTitle(usernameButtonText, for: .normal)
        communityButton.setTitle(comment.community, for: .normal)
        publishedTitle.text = comment.published
        scoreLabel.set(text: String(comment.score), leftIcon: Config.Image.boltFill)
        postNameButton.setTitle(comment.postName, for: .normal)

        if let avatarUrl = comment.avatarImageUrl {
            setupAvatar(url: avatarUrl)
        }
    }

    // MARK: - Private API
    private func setupAvatar(url: String) {
        Nuke.loadImage(with: ImageRequest(url: URL(string: url)!), into: avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize.height)
        }

        stackView.insertArrangedSubview(avatarView, at: 0)
    }

    private func setupViews() {
        
        stackView.addStackViewItems(
            .view(usernameButton),
            .view(toTitle),
            .view(communityButton),
            .view(scoreLabel),
            .view(publishedTitle)
        )
        
        self.addSubview(stackView)
        self.addSubview(postNameButton)

        stackView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
        }

        self.postNameButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupButtonTargets() {
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

// MARK: - CommentCenterView -
private class CommentCenterView: UIView {

    // MARK: - ViewData
    struct ViewData {
        let comment: String
    }

    // MARK: - Properties
    private let commentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with data: CommentCenterView.ViewData) {
        commentLabel.text = data.comment
    }

    // MARK: - Private API
    private func setupUI() {
        self.addSubview(commentLabel)

        commentLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}

// MARK: -
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
    private let showContextButton = UIButton().then {
        let image = Config.Image.link
        $0.setImage(image, for: .normal)
    }

    private let upvoteButton = UIButton().then {
        let image = Config.Image.arrowUp
        $0.setImage(image, for: .normal)
    }
    
    private let downvoteButton = UIButton().then {
        let image = Config.Image.arrowDown
        $0.setImage(image, for: .normal)
    }

    private let replyButton = UIButton().then {
        let image = Config.Image.arrowshapeTurnUp
        $0.setImage(image, for: .normal)
    }

    private let showMoreButton = UIButton().then {
        let image = Config.Image.ellipsis
        $0.setImage(image, for: .normal)
    }

    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.spacing = 40
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func bind(with: CommentFooterView.ViewData) { }

    // MARK: - Overrided
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        replyButton.setImage(Config.Image.arrowshapeTurnUp, for: .normal)
        showMoreButton.setImage(Config.Image.ellipsis, for: .normal)
        upvoteButton.setImage(Config.Image.arrowUp, for: .normal)
        downvoteButton.setImage(Config.Image.arrowDown, for: .normal)
        showContextButton.setImage(Config.Image.link, for: .normal)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }

    // MARK: - Private
    private func setupTargets() {
        showContextButton.addTarget(self, action: #selector(showContextButtonTapped(sender:)), for: .touchUpInside)
        upvoteButton.addTarget(self, action: #selector(upvoteButtonTapped(sender:)), for: .touchUpInside)
        downvoteButton.addTarget(self, action: #selector(downvoteButtonTapped(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(replyButtonTapped(sender:)), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonTapped(sender:)), for: .touchUpInside)
    }

    private func setupUI() {

        // settup up stack view
        self.addSubview(stackView)

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
}
