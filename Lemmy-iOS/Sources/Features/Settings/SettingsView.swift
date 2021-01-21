//
//  SettingsView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate: SettingsTableViewDelegate { }

extension SettingsView {
    struct Appearance { }
}

class SettingsView: UIView {

    // MARK: - Properties
    let appearance: Appearance

    weak var delegate: SettingsViewDelegate? {
        didSet {
            self.tableView.delegate = self.delegate
        }
    }
    
    private lazy var tableView = SettingsTableView(appearance: .init(style: .insetGrouped))

    // MARK: - Init
    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
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
}
extension SettingsView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(self.tableView)
    }

    func makeConstraints() {
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
