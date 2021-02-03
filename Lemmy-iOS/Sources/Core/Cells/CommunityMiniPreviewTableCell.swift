//
//  ChooseCommunityCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 22.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class CommunityMiniPreviewTableCell: UITableViewCell {
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

    let commTitle = UILabel()

    let stackView = UIStackView().then {
        $0.spacing = 8
        $0.alignment = .leading
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        

        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with data: ViewData) {
        self.viewData = data

        commImageView.loadImage(urlString: data.icon, imageSize: imageSize)
        commTitle.text = data.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.commImageView.image = nil
        self.commImageView.isHidden = false
        self.commTitle.text = nil
    }
}

extension CommunityMiniPreviewTableCell: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.contentView.addSubview(stackView)
        stackView.addStackViewItems(
            .view(commImageView),
            .view(commTitle)
        )
    }
    
    func makeConstraints() {
        self.commTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
        }

        self.commImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize)
        }

        self.stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
