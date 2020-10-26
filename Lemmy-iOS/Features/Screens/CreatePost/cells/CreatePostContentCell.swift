//
//  CreatePostContentCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostContentCell: UITableViewCell {
    
    var backView: UIView
    
    lazy var titleTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.textColor = UIColor.lightGray
        tv.placeholder = "Title"
        return tv
    }()
    
    lazy var bodyTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.textColor = UIColor.lightGray
        tv.placeholder = "Body"
        return tv
    }()
    
    lazy var nsfwSwitch: LemmyLabelWithSwitch = {
        let switcher = LemmyLabelWithSwitch()
        switcher.checkText = "Show NSFW content"
        return switcher
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    init(backView: UIView) {
        self.backView = backView
        
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        
        selectionStyle = .none
        
        bodyTextView.delegate = self
        [titleTextView, bodyTextView, nsfwSwitch].forEach { (view) in
            contentView.addSubview(view)
        }
        
        titleTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bodyTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextView.snp.bottom).offset(5)
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(nsfwSwitch)
        nsfwSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(bodyTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(bodyTextView)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreatePostContentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case bodyTextView:
            UIView.animate(withDuration: 0.2) {
                if self.backView.frame.origin.y == 0 {
                    self.backView.frame.origin.y -= 100
                }
            }
        default: break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case bodyTextView:
            UIView.animate(withDuration: 0.2) {
                if self.backView.frame.origin.y != 0 {
                    self.backView.frame.origin.y = 0
                }
            }
        default: break
        }
    }
}
