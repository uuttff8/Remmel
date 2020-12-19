//
//  PostContentPreviewTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class PostContentPreviewTableCell: UITableViewCell {
    
    var postContentView = PostContentView()
    let selBackView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
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

extension PostContentPreviewTableCell: ProgrammaticallyViewProtocol {
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
