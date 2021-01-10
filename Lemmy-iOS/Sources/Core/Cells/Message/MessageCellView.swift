//
//  MessageCellView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol MessageCellViewDelegate: AnyObject {
    func messageCell(_ cell: MessageCellView, didTapUsername username: String)
}

final class MessageCellView: UIView {
    struct MentionViewData {
        let avatar: String?
        let nickname: String
        let published: Date
        let content: String
    }
    
    weak var delegate: MessageCellViewDelegate?
    
    private lazy var avatarImageView = UIImageView()
    private let usernameButton = ResizableButton().then {
        $0.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    private lazy var publishedLabel = UILabel()
    
    private lazy var headerStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var contentLabel = UILabel()
    
    private lazy var replyButton = ImageControl().then {
        $0.innerImageView.image = Config.Image.arrowshapeTurnUp
    }
    
    private lazy var footerStackView = UIStackView()
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    var data: MentionViewData?
    
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
    
    func configure(with data: MentionViewData?) {
        guard let data = data else {
            self.avatarImageView.image = nil
            self.usernameButton.setTitle(nil, for: .normal)
            self.publishedLabel.text = nil
            self.contentLabel.text = nil
            return
        }
        
        setupTargets(with: data)
        self.avatarImageView.loadImage(urlString: data.avatar)
        self.usernameButton.setTitle(data.nickname, for: .normal)
        self.publishedLabel.text = data.published.shortTimeAgoSinceNow
        self.contentLabel.text = data.content
    }
    
    func setupTargets(with data: MentionViewData) {
        self.data = data
        usernameButton.addTarget(self, action: #selector(usernameButtonTapped), for: .touchUpInside)
    }
    
    @objc func usernameButtonTapped() {
        guard let data = data else { return }
        self.delegate?.messageCell(self, didTapUsername: data.nickname)
    }
}

extension MessageCellView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(mainStackView)
        
        self.headerStackView.addStackViewItems(
            .view(avatarImageView),
            .view(usernameButton),
            .view(UIView()),
            .view(publishedLabel)
        )
        
        self.footerStackView.addStackViewItems(
            .view(UIView()),
            .view(replyButton)
        )
        
        self.mainStackView.addStackViewItems(
            .view(headerStackView),
            .view(contentLabel),
            .view(footerStackView)
        )
    }
    
    func makeConstraints() {
        self.avatarImageView.snp.makeConstraints {
            $0.size.equalTo(35)
        }

        self.mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}
