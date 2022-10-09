//
//  ProfileSettingsView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 03.02.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileSettingsViewDelegate: SettingsTableViewDelegate { }

class ProfileSettingsView: UIView {

    // MARK: - Properties

    weak var delegate: ProfileSettingsViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))

    // MARK: - Init
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    
    func configure(viewModel: SettingsTableViewModel) {
        tableView.configure(viewModel: viewModel)
    }
    
    func updateData(viewModel: SettingsTableViewModel) {
        tableView.updateViewModel(viewModel)
    }
    
    func showLoadingIndicator() {
        tableView.showActivityIndicatorView()
    }
    
    func hideLoadingIndicator() {
        tableView.hideActivityIndicatorView()
    }
}

// MARK: - ProgrammaticallyViewProtocol

extension ProfileSettingsView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        addSubview(self.tableView)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
