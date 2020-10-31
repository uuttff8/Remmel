//
//  ChooseCommunityCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class ChooseCommunityCell: UITableViewCell {
    struct ViewData {
        let title: String
        let icon: String?
    }

    // MARK: - Properties
    private var viewData: ViewData?
    private let imageSize = CGSize(width: 30, height: 30)

    lazy var commImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = self.imageSize.height
        return iv
    }()

    let commTitle: UILabel = {
        let lbl = UILabel()
        return lbl
    }()

    let stackView = UIStackView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(stackView)
        self.stackView.addArrangedSubview(commImageView)
        self.stackView.addArrangedSubview(commTitle)
        self.stackView.spacing = 8
        self.stackView.alignment = .leading
        self.stackView.addArrangedSubview(UIView())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with data: ViewData) {
        self.viewData = data

        if let imageString = data.icon, let url = URL(string: imageString) {
            Nuke.loadImage(with: ImageRequest(url: url), into: commImageView)
        } else {
            self.commImageView.isHidden = true
        }

        self.commImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize)
            make.centerY.equalToSuperview()
        }
        self.commTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
        }
        commTitle.text = data.title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
