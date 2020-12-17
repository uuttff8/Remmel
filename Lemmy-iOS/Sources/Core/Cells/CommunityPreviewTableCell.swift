//
//  CommunityPreviewTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

protocol CommunityPreviewTableCellDelegate: AnyObject {
    func communityPreviewCell(_ cell: CommunityPreviewTableCell, didTapped followButton: FollowButton)
}

class CommunityPreviewTableCell: UITableViewCell {
    struct ViewData {
        let imageUrl: String?
        let name: String
        let category: String
        let subscribers: Int
    }

    weak var delegate: CommunityPreviewTableCellDelegate?

    var community: LemmyModel.CommunityView?

    private let iconSize = CGSize(width: 20, height: 20)
    private let followButton = FollowButton()
    
    private let communityNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(community: LemmyModel.CommunityView) {
        self.community = community
//        self.imageView?.loadImage(urlString: community.icon)

        self.communityNameLabel.text = community.name
        self.followButton.bind(isSubcribed: community.subscribed)
        
        followButton.addTarget(self, action: #selector(followButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc func followButtonTapped(sender: FollowButton!) {
        self.delegate?.communityPreviewCell(self, didTapped: sender)
    }
}

extension CommunityPreviewTableCell: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.contentView.addSubview(followButton)
        self.contentView.addSubview(communityNameLabel)
    }
    
    func makeConstraints() {
        communityNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
