//
//  ProfileScreenTableHeaderView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProfileScreenTableHeaderView: UIView {
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
        
    let contentTypeView = LemmyImageTextTypePicker(cases: LemmySortType.self,
                                                   firstPicked: LemmySortType.active,
                                                   image: Config.Image.sortType)
    
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
}

extension ProfileScreenTableHeaderView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .systemBackground
        self.snp.makeConstraints {
            $0.height.equalTo(40.0)
        }
    }
    
    func addSubviews() {
        self.addSubview(mainStackView)
    }
    
    func makeConstraints() {
        mainStackView.addStackViewItems(
            .view(horizontalStackView),
            .customSpace(10)
        )
        
        horizontalStackView.addStackViewItems(
            .view(contentTypeView),
            .view(UIView())
        )
        
        mainStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}
