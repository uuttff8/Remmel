//
//  CommentContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 27.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - CommentCenterView: UIView -
class CommentCenterView: UIView {

    // MARK: - ViewData
    struct ViewData {
        let comment: String
        let isDeleted: Bool
    }

    // MARK: - Properties
    private let commentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func bind(with data: CommentCenterView.ViewData) {
        let commentText: NSAttributedString = data.isDeleted
            ? NSAttributedString(string: "Deleted by creator", attributes: [.font: UIFont.italicSystemFont(ofSize: 17)])
            : NSAttributedString(string: data.comment)
        
        commentLabel.attributedText = commentText
    }

    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}

extension CommentCenterView: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.addSubview(commentLabel)
    }
    
    func makeConstraints() {
        commentLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
