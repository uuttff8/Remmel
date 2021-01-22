//
//  FollowButton.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 17.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol FollowButtonDelegate: AnyObject {
    func followButton(_ followButton: FollowButton, tappedWithState: FollowButton.State)
}

final class FollowButton: LoadingButton {
    
    weak var delegate: FollowButtonDelegate?
    
    enum State {
        case follow
        case followed
        case pending
    }
    
    var followState: State = .follow {
        didSet {
            setState()
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(isSubcribed: Bool?) {
        guard let isSubcribed = isSubcribed else { followState = .follow; return }
        followState = isSubcribed ? .followed : .follow
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        super.addTarget(target, action: action, for: controlEvents)
        
        if controlEvents == .touchUpInside {
            currentButtonTapped()
        }
    }
    
    private func setState() {
        switch followState {
        case .follow:
            hideLoading()
            setTitle("follow-follow".localized, for: .normal)
            setTitleColor(.systemRed, for: .normal)
        case .followed:
            hideLoading()
            setTitle("follow-unfollow".localized, for: .normal)
            setTitleColor(.lemmyBlue, for: .normal)
        case .pending:
            showLoading()
        }
    }
    
    // MARK: Action methods
    
    @objc private func currentButtonTapped() {
        delegate?.followButton(self, tappedWithState: followState)
    }
}
