//
//  ProfileChangePasswordView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.05.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ProfileChangePasswordViewDelegate: SettingsTableViewDelegate { }

class ProfileChangePasswordView: UIView {

    // MARK: - Properties

    weak var delegate: ProfileChangePasswordViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))

    // MARK: - Init
    override init(
        frame: CGRect = .zero
    ) {
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
        self.tableView.configure(viewModel: viewModel)
    }
    
    func updateData(viewModel: SettingsTableViewModel) {
        self.tableView.updateViewModel(viewModel)
    }
    
    func showLoadingIndicator() {
        self.tableView.showActivityIndicatorView()
    }
    
    func hideLoadingIndicator() {
        self.tableView.hideActivityIndicatorView()
    }
}
extension ProfileChangePasswordView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(self.tableView)
    }

    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
