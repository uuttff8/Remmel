//
//  CommunityHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityHeaderCell: UITableViewCell {
    
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
        
    let communityHeaderView = CommunityHeaderView()
    let contentTypeView = LemmyImageTextTypePicker(cases: LemmySortType.self,
                                                   firstPicked: LemmySortType.active,
                                                   image: Config.Image.sortType)
        
    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        selectionStyle = .none
        self.backgroundColor = .systemBackground
        
        contentView.addSubview(mainStackView)
    }
    
    func bindData(community: LemmyModel.CommunityView) {
        communityHeaderView.bind(with: community)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CommunityTableHeaderView: UIView {
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
        
    let communityHeaderView = CommunityHeaderView()
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
    
    func bindData(community: LemmyModel.CommunityView) {
        communityHeaderView.bind(with: community)
    }
}

extension CommunityTableHeaderView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        self.addSubview(mainStackView)
    }
    
    func makeConstraints() {
        mainStackView.addStackViewItems(
            .view(communityHeaderView),
            .view(UIView.Configutations.separatorView),
            .view(horizontalStackView),
            .customSpace(10)
        )
        
        horizontalStackView.addStackViewItems(
            .view(contentTypeView),
            .view(UIView())
        )
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}
