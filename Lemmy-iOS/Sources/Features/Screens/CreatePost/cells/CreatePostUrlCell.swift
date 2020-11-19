//
//  CreatePostContentCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 21.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreatePostUrlCell: UITableViewCell {

    var onPickImage: (() -> Void)?
    var onPickedImage: ((UIImage) -> Void)?
    var isImagePicked = false

    var urlText: String {
        if isImagePicked {
            return "https://dev.lemmy.ml/pictrs/image/" + (urlTextField.text ?? "")
        } else {
            return urlTextField.text ?? ""
        }
    }

    lazy var selectImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "photo"), for: .normal)
        return btn
    }()

    lazy var urlTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "URL"
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        [selectImageButton, urlTextField].forEach { (view) in
            contentView.addSubview(view)
        }

        urlTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(selectImageButton.snp.leading)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }

        selectImageButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(30)
            make.bottom.equalTo(urlTextField)
        }

        selectImageButton.addTarget(self,
                                    action: #selector(handleImageButtonTap),
                                    for: .touchUpInside)
    }

    @objc private func handleImageButtonTap() {
        onPickImage?()
        onPickedImage = { [self] image in
            isImagePicked = true
            ApiManager.requests.uploadPictrs(image: image) { (res) in
                switch res {
                case .success(let response):
                    if let filename = response.files.first?.file {
                        self.urlTextField.text = "" + filename
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
