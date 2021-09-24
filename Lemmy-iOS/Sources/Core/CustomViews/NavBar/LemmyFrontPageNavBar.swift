//
//  LemmyFrontPageNavBar.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

class LemmyFrontPageNavBar: UIView {
    var onProfileIconTap: (() -> Void)?
    var onSettingsIconTap: (() -> Void)?
    
    let searchBar = LemmySearchBar()
    private lazy var profileIcon = LemmyProfileIconView()
    private lazy var settingsIcon = LemmyNavSettingsView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func updateProfileIcon() {
        guard let photoStr = LemmyShareData.shared.userdata?.localUserView.person.avatar
        else {
            self.profileIcon.imageButton.setImage(UIImage(systemName: "person"), for: .normal)
            return
        }

        ImagePipeline.shared.loadImage(
            with: photoStr.asImageRequest(),
            completion: { (result: Result<ImageResponse, ImagePipeline.Error>) in
                switch result {
                case let .success(response):
                    self.profileIcon.imageButton.setImage(response.image, for: .normal)
                default: break
                }
            }
        )
    }
    
    @objc private func profileIconTapped() {
        onProfileIconTap?()
    }
    
    @objc private func settingsIconTapped() {
        onSettingsIconTap?()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

extension LemmyFrontPageNavBar: ProgrammaticallyViewProtocol {
    func setupView() {
        profileIcon.imageButton.addTarget(self, action: #selector(profileIconTapped), for: .touchUpInside)
        settingsIcon.imageButton.addTarget(self, action: #selector(settingsIconTapped), for: .touchUpInside)
        
        if LemmyShareData.shared.isLoggedIn {
            updateProfileIcon()
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProfileIcon),
                                               name: .didLogin,
                                               object: nil)
    }
    
    func addSubviews() {
        self.addSubview(searchBar)
        self.addSubview(profileIcon)
        self.addSubview(settingsIcon)
    }
    
    func makeConstraints() {
        self.searchBar.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(50)  // left icon
            make.trailing.equalToSuperview().inset(50) // right icon
        }

        self.profileIcon.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(searchBar.snp.trailing)
            make.trailing.equalToSuperview()
        }
        
        self.settingsIcon.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(searchBar.snp.leading)
            make.leading.equalToSuperview()
        }
    }
}
