//
//  ProfileScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension ProfileScreenViewController {
    class View: UIView {
        
        private let titleLabel = UILabel().then {
            $0
        }
        
        struct ViewData {
            let name: String
            let avatarUrl: URL?
            let bannerUrl: URL?
            let numberOfComments: Int
            let numberOfPosts: Int
            let published: Date
        }
        
        private let tabsTitles: [String]
        
        init(frame: CGRect = .zero, tabsTitles: [String]) {
            self.tabsTitles = tabsTitles
            super.init(frame: frame)
            
            self.setupView()
            self.addSubviews()
            self.makeConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(viewData: ViewData) {
            titleLabel.text = viewData.name
        }
    }
}

extension ProfileScreenViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .systemBackground
    }

    func addSubviews() {
        self.addSubview(titleLabel)
    }

    func makeConstraints() {
        self.titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
