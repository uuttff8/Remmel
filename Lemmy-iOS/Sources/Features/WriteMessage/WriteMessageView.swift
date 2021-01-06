//
//  WriteMessageView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - CreateCommunityUI: UIView -
class WriteMessageView: UIView {
    
    // MARK: - Properties
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))
    
    // MARK: - Init
    override init(
        frame: CGRect = .zero
    ) {
        super.init(frame: .zero)
        
        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: SettingsTableViewModel) {
        self.tableView.configure(viewModel: viewModel)
    }
}

extension WriteMessageView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
