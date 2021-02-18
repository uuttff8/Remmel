//
//  LemmyOutlinePostEmbedView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyOutlinePostEmbedView: UIControl {

    struct Data {
        let title: String?
        let description: String?
        let url: URL?
    }
    
    private let topTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15)
    }
    
    private let urlLabel = UILabel().then {
        $0.font = .italicSystemFont(ofSize: 14)
        $0.textColor = .lemmySecondLabel
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    let containerView = UIView().then {
        $0.isUserInteractionEnabled = false
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

    func bindData(_ viewData: Data) {
        if let link = viewData.url {
            urlLabel.text = link.host
        }
        topTitleLabel.text = viewData.title
        descriptionLabel.text = viewData.description
                
        self.urlLabel.isHidden = viewData.url == nil ? true : false
        self.descriptionLabel.isHidden = viewData.description == nil ? true : false
        self.topTitleLabel.isHidden = viewData.title == nil ? true : false
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = self.isHighlighted ? 0.6 : 1.0
        }
    }
}

extension LemmyOutlinePostEmbedView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor.lemmyBlue.cgColor
        self.containerView.backgroundColor = UIColor.systemGray6
    }
    
    func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        self.mainStackView.addStackViewItems(
            .view(urlLabel),
            .customSpace(2),
            .view(topTitleLabel),
            .view(descriptionLabel)
        )
    }
    
    func makeConstraints() {
        self.containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
