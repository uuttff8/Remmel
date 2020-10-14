//
//  LemmyFrontPageNavBar.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Nuke

extension UIButton: Nuke_ImageDisplaying {
    public func nuke_display(image: Nuke.PlatformImage?) {
        self.setImage(image, for: .normal)
    }
}

class LemmyFrontPageNavBar: UIView {
    let searchBar = LemmySearchBar()
    let profileIcon = LemmyProfileIconView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        self.addSubview(searchBar)
        self.addSubview(profileIcon)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProfileIcon(_:)),
                                               name: .didLogin,
                                               object: nil)
    }
    
    @objc func updateProfileIcon(_ notification: Notification) {
        guard let photoUrl = LemmyShareData.shared.userdata?.avatar else { return }
        
        ImagePipeline.shared.loadImage(
            with: URL(string: photoUrl)!,
            progress: { _, completed, total in
                print("progress updated")
            },
            completion: { (result: Result<ImageResponse, ImagePipeline.Error>) in
                switch result {
                case let .success(response):
                    self.profileIcon.imageButton.setImage(response.image, for: .normal)
                default: break
                }
            }
        )
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.searchBar.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(50)
        }
        
        self.profileIcon.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(searchBar.snp.trailing)
            make.trailing.equalToSuperview().offset(10)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}
