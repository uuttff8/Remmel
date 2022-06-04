//
//  CreateCommunityUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CreateCommunityViewDelegate: SettingsTableViewDelegate { }

extension CreateCommunityUI {
    struct Appearance {
    }
}

// MARK: - CreateCommunityUI: UIView -
class CreateCommunityUI: UIView {
    
    // MARK: - Properties
    
    let appearance: Appearance
    
    weak var delegate: CreateCommunityViewDelegate? {
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

extension CreateCommunityUI: ProgrammaticallyViewProtocol {
    func setupView() {
        
    }
    
    func addSubviews() {
        self.addSubview(tableView)
    }
    
    func makeConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
