//
//  MessageTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit
import DateToolsSwift

final class MessageTableCell: UITableViewCell {
    private lazy var cellView = MessageCellView()
    
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

    func configure(viewModel: LemmyModel.PrivateMessageView) {
        self.cellView.configure(
            with: .init(
                avatar: viewModel.recipientAvatar,
                nickname: viewModel.recipientName,
                published: viewModel.published,
                content: viewModel.content
            )
        )
    }
    
    private func setupSubview() {
        self.contentView.addSubview(self.cellView)

        self.clipsToBounds = true
        self.contentView.clipsToBounds = true

        self.cellView.translatesAutoresizingMaskIntoConstraints = false
        self.cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
