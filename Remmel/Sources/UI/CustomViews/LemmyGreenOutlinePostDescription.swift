//
//  LemmyOutlinePostEmbedView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyOutlinePostEmbedView: UIView {

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
    
    private let containerView = UIView().then {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.6
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
}

extension LemmyOutlinePostEmbedView: ProgrammaticallyViewProtocol {
    func setupView() {
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.lemmyBlue.cgColor
        containerView.backgroundColor = UIColor.systemGray6
    }
    
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        mainStackView.addStackViewItems(
            .view(urlLabel),
            .customSpace(2),
            .view(topTitleLabel),
            .view(descriptionLabel)
        )
    }
    
    func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
