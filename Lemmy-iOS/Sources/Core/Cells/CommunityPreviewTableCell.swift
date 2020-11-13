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

    let community: LemmyModel.CommunityView

    private let iconSize = CGSize(width: 20, height: 20)
    private let followButton: UIButton = {
        let btn = UIButton()
        return btn
    }()

    init(community: LemmyModel.CommunityView) {
        self.community = community
        super.init(style: .subtitle, reuseIdentifier: nil)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {
        if let imageUrl = community.icon {
//            self.imageView!.image = UIImage(systemName: "hourglass.tophalf.fill")
            Nuke.loadImage(with: ImageRequest(url: URL(string: imageUrl)!), into: self.imageView!)
        }

        self.textLabel?.text = community.name
        self.detailTextLabel?.text = community.categoryName
        self.followButton.setTitle("Follow", for: .normal)
        self.followButton.setTitleColor(UIColor.systemBlue, for: .normal)

        self.addSubview(followButton)

        followButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        followButton.addTarget(self, action: #selector(followButtonTapped(sender:)), for: .touchUpInside)
    }

    @objc func followButtonTapped(sender: UIButton!) {
        self.delegate?.follow(to: community)
    }
}
