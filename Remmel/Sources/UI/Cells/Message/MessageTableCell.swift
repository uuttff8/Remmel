//
//  MessageTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

final class MessageTableCell: UITableViewCell {
    private lazy var cellView = MessageCellView()
    
    weak var delegate: MessageCellViewDelegate? {
        get { self.cellView.delegate }
        set { self.cellView.delegate = newValue }
    }
    
    private var bottomSeparator = ViewPreConfigutations.separatorView
    
    override func updateConstraintsIfNeeded() {
        super.updateConstraintsIfNeeded()

        if self.cellView.superview == nil {
            self.setupSubview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellView.configure(with: nil)
    }

    func configure(viewModel: RMModel.Views.PrivateMessageView) {
        self.cellView.configure(
            with: .init(
                id: viewModel.recipient.id,
                avatar: viewModel.recipient.avatar,
                nickname: viewModel.recipient.name,
                published: viewModel.privateMessage.published.toLocalTime(),
                content: viewModel.privateMessage.content
            )
        )
    }
    
    private func setupSubview() {
        self.contentView.addSubview(self.cellView)
        self.contentView.addSubview(self.bottomSeparator)

        self.clipsToBounds = true
        self.contentView.clipsToBounds = true

        self.cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.bottomSeparator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
