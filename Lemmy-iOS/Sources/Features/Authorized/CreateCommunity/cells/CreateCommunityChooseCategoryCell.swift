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

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with data: ViewData, showDisclosure: Bool) {
        self.accessoryType = showDisclosure ? .disclosureIndicator : .none
        self.viewData = data

        textLabel?.text = data.title
    }
}

extension CreateCommunityChooseCategoryCell: ProgrammaticallyViewProtocol {
    func setupView() {
        textLabel?.text = "Choose Category"
    }
    
    func addSubviews() {
    }
    
    func makeConstraints() {
        
    }
}
