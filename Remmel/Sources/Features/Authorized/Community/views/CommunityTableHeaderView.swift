//
//  CommunityTableHeaderView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol CommunityTableHeaderViewDelegate: CommunityHeaderViewDelegate {}

final class CommunityTableHeaderView: UIView {
    
    weak var delegate: CommunityTableHeaderViewDelegate?
    
    let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }
        
    let communityHeaderView = CommunityHeaderView()
//    let contentTypeView = LemmyImageTextTypePicker(cases: RMModel.Others.SortType.allCases,
//                                                   firstPicked: RMModel.Others.SortType.active,
//                                                   image: Config.Image.sortType)
    
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
    
    func bindData(community: RMModel.Views.CommunityView) {
        communityHeaderView.bind(with: community)
        communityHeaderView.delegate = delegate
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
            .view(UIView.ViewPreConfigutations.separatorView),
            .view(horizontalStackView),
            .customSpace(10)
        )
//        
//        horizontalStackView.addStackViewItems(
//            .view(contentTypeView),
//            .view(UIView())
//        )
        
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
