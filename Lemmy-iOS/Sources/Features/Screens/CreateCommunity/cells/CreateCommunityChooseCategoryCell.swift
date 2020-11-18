//
//  CreateCommunityChooseCategoryCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityChooseCategoryCell: UITableViewCell {
    struct ViewData {
        let title: String
    }

    // MARK: - Properties
    private var viewData: ViewData?

    let commTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Choose Category"
        return lbl
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(commTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with data: ViewData, showDisclosure: Bool) {
        self.accessoryType = showDisclosure ? .disclosureIndicator : .none
        self.viewData = data

        commTitle.text = data.title
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.commTitle.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
