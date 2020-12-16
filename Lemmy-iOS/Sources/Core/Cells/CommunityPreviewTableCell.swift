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
    func follow(to community: LemmyModel.CommunityView)
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
    private let followButton = UIButton()

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
        self.imageView?.loadImage(urlString: community.icon)

        self.textLabel?.text = community.name
        self.detailTextLabel?.text = community.categoryName
        self.followButton.setTitle("Follow", for: .normal)
        self.followButton.setTitleColor(UIColor.systemBlue, for: .normal)
        
        followButton.addTarget(self, action: #selector(followButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc func followButtonTapped(sender: UIButton!) {
        guard let community = community else { return }
        self.delegate?.follow(to: community)
    }
}

extension CommunityPreviewTableCell: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(followButton)
    }
    
    func makeConstraints() {
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
