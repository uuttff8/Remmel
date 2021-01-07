//
//  MessageCellView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

final class MessageCellView: UIView {
    struct MentionViewData {
        let avatar: String?
        let nickname: String
        let published: Date
        let content: String
    }
    
    private lazy var avatarImageView = UIImageView()
    private lazy var nicknameLabel = UILabel()
    private lazy var publishedLabel = UILabel()
    
    private lazy var headerStackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private lazy var contentLabel = UILabel()
    
    private lazy var replyButton = ImageControl()
    
    private lazy var footerStackView = UIStackView()
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
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
            self.nicknameLabel.text = nil
            self.publishedLabel.text = nil
            self.contentLabel.text = nil
            return
        }
        
        self.avatarImageView.loadImage(urlString: data.avatar)
        self.nicknameLabel.text = data.nickname
        self.publishedLabel.text = data.published.shortTimeAgoSinceNow
        self.contentLabel.text = data.content
    }
}

extension MessageCellView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(headerStackView)
        self.addSubview(mainStackView)
        
        self.headerStackView.addStackViewItems(
            .view(avatarImageView),
            .view(nicknameLabel),
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
        self.mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
