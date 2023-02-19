//
//  CommunityPreviewTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/14/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

class CommunityPreviewTableCell: UITableViewCell {
    
    var delegate: CommunityPreviewCellViewDelegate? {
        get { previewView.delegate }
        set { previewView.delegate = newValue }
    }
    
    private let previewView = CommunityPreviewCellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(community: RMModel.Views.CommunityView) {
        self.previewView.configure(with: community)
    }
}

extension CommunityPreviewTableCell: ProgrammaticallyViewProtocol {
    func setupView() { }
    
    func addSubviews() {
        self.contentView.addSubview(previewView)
    }
    
    func makeConstraints() {
        self.previewView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
 
