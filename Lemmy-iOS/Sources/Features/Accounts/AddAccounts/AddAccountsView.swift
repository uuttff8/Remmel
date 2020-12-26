//
//  AddAccountsView.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class AddAccountsView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddAccountsView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .white
    }
    
    func addSubviews() {
    }
    
    func makeConstraints() {
    }
}
