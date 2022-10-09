//
//  EditPostView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 19.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol EditPostViewDelegate: SettingsTableViewDelegate { }

// MARK: - EditPostView: UIView -
class EditPostView: UIView {
    
    weak var delegate: EditPostViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    
    // MARK: - Properties
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))
    
    // MARK: - Init
    override init(frame: CGRect = .zero) {
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
        tableView.configure(viewModel: viewModel)
    }
    
    func updateViewModel(_ viewModel: SettingsTableViewModel) {
        tableView.updateViewModel(viewModel)
    }
}

extension EditPostView: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
