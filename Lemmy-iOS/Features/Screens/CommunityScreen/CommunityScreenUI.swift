//
//  CommunityScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

extension CommunityScreenViewController {
    
    class CommunityScreenUI: UIView {
        
        let mainStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        let scrollView = UIScrollView().then {
            $0.alwaysBounceVertical = true
        }
        
        let communityHeaderView = CommunityHeaderCell()
        let contentTypeView = CommunityContentTypePickerCell()
        
        var presentParsedVc: ((String) -> Void)?
        
        let model: CommunityScreenModel
        var cancellable = Set<AnyCancellable>()
        
        init(model: CommunityScreenModel) {
            self.model = model
            super.init(frame: .zero)
            bindData()
            
            self.backgroundColor = .systemBackground
            
            addSubview(scrollView)
            scrollView.addSubview(mainStackView)
            
            mainStackView.addStackViewItems(
                .view(communityHeaderView),
                .view(UIView.Configutations.separatorView),
                .view(contentTypeView)
            )            
        }
        
        private func bindData() {
            model.communitySubject
                .receive(on: RunLoop.main)
                .compactMap { $0 }
                .sink { [self] in
                    communityHeaderView.bind(with: $0)
                }.store(in: &cancellable)
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            scrollView.snp.makeConstraints {
                $0.edges.equalTo(self)
            }
            
            scrollView.contentLayoutGuide.snp.makeConstraints {
                $0.width.equalTo(self)
            }
            
            mainStackView.snp.makeConstraints {
                $0.edges.equalTo(scrollView.contentLayoutGuide).inset(10)
            }
        }
    }
}
