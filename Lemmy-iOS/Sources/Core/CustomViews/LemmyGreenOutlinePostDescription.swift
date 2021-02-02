//
//  LemmyGreenOutlinePostEmbed.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/28/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyGreenOutlinePostEmbed: UIView {

    struct Data {
        let title: String?
        let description: String?
        let url: String?
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let containerView = UIView()

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
        titleLabel.text = viewData.title
        descriptionLabel.text = viewData.description

        if viewData.description == nil {
            self.descriptionLabel.isHidden = true
        }
        
        if viewData.title == nil {
            self.titleLabel.isHidden = true
        }
    }
}

extension LemmyGreenOutlinePostEmbed: ProgrammaticallyViewProtocol {
    func setupView() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func addSubviews() {
        self.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        self.mainStackView.addStackViewItems(
            .view(titleLabel),
            .view(descriptionLabel)
        )
    }
    
    func makeConstraints() {
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        
        self.mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
