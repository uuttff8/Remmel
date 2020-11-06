//
//  LemmySortListingPickersView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmySortListingPickersView: UIView {
    
    enum PostListingAdapted: String, Codable, CaseIterable, LemmyTypePickable {
        case all = "All"
        case subscribed = "Subscribed"
        
        var toInitiallyListing: LemmyPostListingType {
            switch self {
            case .all: return LemmyPostListingType.all
            case .subscribed: return LemmyPostListingType.subscribed
            }
        }
        
        var label: String {
            switch self {
            case .all: return "All"
            case .subscribed: return "Subscribed"
            }
        }
    }
    
    let sortTypeView = LemmyImageTextTypePicker(
        cases: LemmySortType.self,
        firstPicked: .active,
        image: Config.Image.sortType
    )
    
    let listingTypeView = LemmyImageTextTypePicker(
        cases: PostListingAdapted.self,
        firstPicked: .all,
        image: Config.Image.postListing
    )
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .equalSpacing
    }
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(stackView)
        
        stackView.addStackViewItems(
            .view(sortTypeView),
            .view(listingTypeView)
        )
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(25)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
