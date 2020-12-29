//
//  AddAccountsView.swift
//  Lemmy-iOS
//
//  Created by Komolbek Ibragimov on 25/12/2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// for future
protocol AddAccountViewDelegate: AnyObject {
    func addAccountView(_ view: AddAccountView, isEnableAddButton: Bool)
}

final class AddAccountView: UIView {
    
    weak var delegate: AddAccountViewDelegate?
    
    lazy var authView = AuthenticationView()
    lazy var registerView = RegisterView()
    
    private let authMethod: LemmyAuthMethod
    
    init(authMethod: LemmyAuthMethod) {
        self.authMethod = authMethod
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

extension AddAccountView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.backgroundColor = .white
    }
    
    func addSubviews() {
        switch authMethod {
        case .auth:
            self.addSubview(authView)
        case .register:
            self.addSubview(registerView)
        }
    }
    
    func makeConstraints() {
        switch authMethod {
        case .auth:
            self.authView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        case .register:
            self.registerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
