//
//  InboxMessagesView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

final class InboxMessagesView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InboxMessagesView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .green
    }
    
    func addSubviews() {
        
    }
    
    func makeConstraints() {
        
    }
}
