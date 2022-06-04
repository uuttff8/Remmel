//
//  CreateCommunitySidebarCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 30.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunitySidebarCell: UITableViewCell {

    let backView: UIView

    lazy var sidebarTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.textColor = UIColor.lightGray
//        tv.placeholder = "Sidebar"
        return tv
    }()

    init(backView: UIView) {
        self.backView = backView
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        selectionStyle = .none

        contentView.addSubview(sidebarTextView)

        sidebarTextView.delegate = self
        sidebarTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView).inset(5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateCommunitySidebarCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2) {
            if self.backView.frame.origin.y == 0 {
                self.backView.frame.origin.y -= 300
            }
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2) {
            if self.backView.frame.origin.y != 0 {
                self.backView.frame.origin.y = 0
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
}
