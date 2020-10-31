//
//  CreateCommunityImagesCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 29.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CreateCommunityImagesCell: UITableViewCell {

    enum ImagePick {
        case icon
        case banner
    }

    // Properties
    var onPickImage: ((ImagePick) -> Void)?
    var onPickedImage: ((UIImage, ImagePick) -> Void)?

    var iconImageString: String?
    var bannerImageString: String?

    private let iconView = LemmyLabelDownerImageView(imageName: "camera.circle.fill", labelText: "Icon")
    private let bannerView = LemmyLabelDownerImageView(imageName: "camera.circle.fill", labelText: "Banner")

    init() {
        super.init(style: .default, reuseIdentifier: String(describing: Self.self))
        selectionStyle = .none

        let screenWidth = UIScreen.main.bounds.width

        [iconView, bannerView].forEach { (view) in
            contentView.addSubview(view)
        }

        iconView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(screenWidth / 2.5)
        }

        bannerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(screenWidth / 2.5)
            make.bottom.equalToSuperview().inset(5)
        }

        self.iconView.iconImageView.addTap {
            self.onPickImage?(.icon)
        }

        self.bannerView.iconImageView.addTap {
            self.onPickImage?(.banner)
        }

        self.onPickedImage = { image, imagePick in

            switch imagePick {
            case .icon:
                self.iconView.iconImageView.image = image
                self.loadImage(image: image) { (filename) in
                    self.iconImageString = filename
                }
            case .banner:
                self.bannerView.iconImageView.image = image
                self.loadImage(image: image) { (filename) in
                    self.bannerImageString = filename
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadImage(image: UIImage, completion: @escaping ((String) -> Void)) {
        ApiManager.requests.uploadPictrs(image: image) { (res) in
            switch res {
            case .success(let response):
                completion(response.files.first!.file)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

class LemmyLabelDownerImageView: UIView {
    let imageName: String
    let labelText: String

    lazy var iconTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = labelText
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()

    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .black)

        iv.image = UIImage(systemName: imageName, withConfiguration: config)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        iv.alpha = 0.5
        return iv
    }()

    init(imageName: String, labelText: String) {
        self.imageName = imageName
        self.labelText = labelText
        super.init(frame: .zero)

        [iconTitle, iconImageView].forEach { (view) in
            self.addSubview(view)
        }

        iconTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.leading.equalTo(iconImageView.snp.leading)
        }

        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(iconTitle.snp.bottom).offset(10)
            make.size.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
